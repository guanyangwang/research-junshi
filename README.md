# Research Advisor — General (Claude Code Skill)

A Claude Code skill that acts as your daily **军师** (strategic research advisor) for **any academic field**. Tell it your research problem and point it to your papers — it monitors arxiv and top venues every day, reads your work, and proposes bold, ranked research ideas saved as a daily digest.

Works for ML, NLP, computer vision, robotics, biology, physics, economics, statistics, and more.

## What it does

- **Learns your research** by reading your papers — your methods, contributions, open problems, and taste
- **Asks you about your field and venues** on first run; picks smart defaults if you skip
- **Searches arxiv daily** across the categories relevant to your field
- **Monitors your target venues** (NeurIPS, ACL, Nature, ICRA, or whatever you care about)
- **Summarizes** the most relevant papers — key insight, what they leave open, why it matters to you
- **Generates bold ideas** in 军师 mode: cross-pollinated, gap-exploiting, not incremental
- **Ranks ideas** by Novelty × 0.4 + Feasibility × 0.3 + Impact × 0.3
- **Saves a daily digest** to `~/.claude/research-advisor/digests/YYYY-MM-DD.md`

## Installation

```bash
git clone https://github.com/guanyangwang/research-advisor-general.git ~/.claude/skills/research-advisor-general
```

Then reload plugins in Claude Code:

```
/reload-plugins
```

Also install `poppler` for PDF reading (if you haven't already):

```bash
brew install poppler        # macOS
apt install poppler-utils   # Linux
```

## Usage

### First run

Just describe your situation naturally:

```
I'm researching causal inference in economics. My papers are in ~/papers/.
I'm thinking about better ways to handle high-dimensional confounders.
Run the research advisor.
```

Claude will ask a few follow-up questions (which venues to watch, etc.) and make smart guesses if you skip anything. It reads your papers, builds a profile, and generates today's digest.

### Daily digest

```
Give me today's research digest.
```

### Set up automatic daily runs (fully automatic, no Claude Code session needed)

```bash
bash ~/.claude/skills/research-advisor-general/setup_automation.sh
```

The script asks for your preferred time (e.g. `08:00`) and sets up a cron job. Digests appear in `~/.claude/research-advisor/digests/` each morning with no action required.

> **Note**: Automated runs use `--dangerously-skip-permissions` so Claude can run headlessly. Permissions are scoped to Read, Write, WebFetch, and WebSearch only — no destructive operations.

### Update your profile

```
Update my research advisor profile. I've shifted focus to [new direction].
```

## Output

Each digest is saved to `~/.claude/research-advisor/digests/YYYY-MM-DD.md`:

- **Today's landscape** — what the field is doing right now
- **Top papers** — summaries of the most relevant arxiv + venue papers
- **Ranked ideas** — top 3-5 bold directions with scores, pitch, first experiment, and main risk
- **Raw ideas** — unfiltered brainstorm



## Supported Fields

The skill adapts to any research area. Built-in venue knowledge covers:

| Field | Example venues |
|---|---|
| Machine Learning | NeurIPS, ICML, ICLR, JMLR |
| Computer Vision | CVPR, ICCV, ECCV |
| NLP | ACL, EMNLP, NAACL |
| Robotics | ICRA, RSS, CoRL |
| Biology | Nature, Science, Cell, Bioinformatics |
| Physics | PRL, PRX, Nature Physics |
| Economics / Statistics | Econometrica, AER, Annals of Statistics |
| Systems / HCI | SOSP, OSDI, CHI, UIST |

If your field or venue isn't listed, just tell Claude — it will adapt.

## Files created by the skill

```
~/.claude/research-advisor/
├── profile.md          ← your research profile (rebuilt on "update my profile")
├── config.md           ← field, venues, arxiv categories, papers folder
└── digests/
    ├── 2026-03-15.md
    ├── 2026-03-16.md
    └── ...
```

These are personal — they are not part of this repo and should not be committed.

## Customization

Edit `SKILL.md` to adjust:
- Idea scoring weights (default: novelty 0.4, feasibility 0.3, impact 0.3)
- Number of ideas per digest
- Digest format and sections
- How aggressively the skill suggests bold vs. conservative ideas

---

Built with the [skill-creator](https://github.com/anthropics/claude-code) plugin for Claude Code.
If you find this useful, feel free to open issues or PRs.
