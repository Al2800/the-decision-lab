# Content ideas

Daily outputs from the **content scout** automation live here as dated
markdown files (`YYYY-MM-DD.md`).

These are working notes for X drafts and blog outlines — not published site
content. Published posts stay under `content/blog/`.

## Automation

1. Create a Cursor Automation at https://cursor.com/automations
2. Trigger: **Scheduled → daily** (or cron, e.g. `0 8 * * *` UTC)
3. Repository: **this repo** on `main` (required for cron so the agent can read/write)
4. Tools: pull request creation on; Memories on; optional Slack digest
5. Prompt: paste `.cursor/automations/daily-content-scout.md`

The agent should only open a PR when there is something new worth drafting.
See `_TEMPLATE.md` for the expected file shape.
