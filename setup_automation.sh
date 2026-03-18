#!/bin/bash
# Research Advisor (General) — Automation Setup
# Run this once to schedule daily digests automatically.

set -e

echo ""
echo "=== Research Advisor (General): Daily Automation Setup ==="
echo ""

# --- Find claude CLI ---
CLAUDE_BIN=$(which claude 2>/dev/null || echo "")
if [ -z "$CLAUDE_BIN" ]; then
  echo "Error: 'claude' CLI not found. Make sure Claude Code is installed and 'claude' is in your PATH."
  exit 1
fi
echo "Found claude CLI at: $CLAUDE_BIN"

# --- Preferred run time ---
read -p "What time should the digest run daily? (e.g. 09:00, default 08:00): " RUN_TIME
RUN_TIME=${RUN_TIME:-08:00}
HOUR=$(echo "$RUN_TIME" | cut -d: -f1)
MINUTE=$(echo "$RUN_TIME" | cut -d: -f2)

# --- Papers folder ---
read -p "Path to your papers folder (e.g. ~/papers, press Enter to skip): " PAPERS_FOLDER
PAPERS_FOLDER=${PAPERS_FOLDER:-""}

# --- Output folder ---
DIGEST_DIR="$HOME/.claude/research-advisor/digests"
mkdir -p "$DIGEST_DIR"
echo "Digests will be saved to: $DIGEST_DIR"

# --- Write permissions settings file ---
SETTINGS_DIR="$HOME/.claude/research-advisor"
SETTINGS_FILE="$SETTINGS_DIR/automation_settings.json"
mkdir -p "$SETTINGS_DIR"

cat > "$SETTINGS_FILE" <<EOF
{
  "permissions": {
    "allow": [
      "WebFetch",
      "WebSearch",
      "Read",
      "Write",
      "Bash(mkdir:*)",
      "Bash(pdftotext:*)"
    ],
    "deny": []
  }
}
EOF
echo "Permissions config written to: $SETTINGS_FILE"

# --- Build the prompt ---
if [ -n "$PAPERS_FOLDER" ]; then
  PROMPT="Run my research advisor daily digest. My papers are in $PAPERS_FOLDER. Load my profile from ~/.claude/research-advisor/profile.md if it exists, otherwise do setup first. Save today's digest to ~/.claude/research-advisor/digests/\$(date +%Y-%m-%d).md"
else
  PROMPT="Run my research advisor daily digest. Load my profile from ~/.claude/research-advisor/profile.md and save today's digest to ~/.claude/research-advisor/digests/\$(date +%Y-%m-%d).md"
fi

# --- Write cron job ---
CRON_CMD="$MINUTE $HOUR * * * $CLAUDE_BIN --dangerously-skip-permissions -p \"$PROMPT\" >> $DIGEST_DIR/cron-general.log 2>&1"

# Check if cron job already exists
EXISTING=$(crontab -l 2>/dev/null | grep "research-advisor-general" || true)
if [ -n "$EXISTING" ]; then
  echo ""
  echo "Existing research-advisor-general cron job found:"
  echo "  $EXISTING"
  read -p "Replace it? (y/n, default y): " REPLACE
  REPLACE=${REPLACE:-y}
  if [ "$REPLACE" != "y" ]; then
    echo "Skipping cron setup. Existing job kept."
    exit 0
  fi
  # Remove old job
  crontab -l 2>/dev/null | grep -v "research-advisor-general" | crontab -
fi

# Add new cron job
(crontab -l 2>/dev/null; echo "# research-advisor-general daily digest"; echo "$CRON_CMD") | crontab -

echo ""
echo "=== Setup complete! ==="
echo ""
echo "Your daily digest will run every day at $RUN_TIME."
echo "Digests saved to:  $DIGEST_DIR/"
echo "Cron log at:       $DIGEST_DIR/cron-general.log"
echo ""
echo "To check the cron job:"
echo "  crontab -l"
echo ""
echo "To remove it:"
echo "  crontab -l | grep -v research-advisor-general | crontab -"
echo ""
echo "To run a digest right now:"
echo "  $CLAUDE_BIN --dangerously-skip-permissions -p \"Run my research advisor general daily digest.\""
