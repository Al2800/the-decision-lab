# The Decision Lab

A personal blog, built with [Hugo](https://gohugo.io/) and the vendored
[Hugo Bear Blog](https://github.com/janraasch/hugo-bearblog) theme.
Currently focused on one project: the FPL Agentic Decision Laboratory.
.
Diagrams are tldraw wireframes embedded as SVG — never stock imagery.

## Local development

Hugo (extended) is installed as a standalone binary at `~/bin/hugo`.
Add `~/bin` to your PATH, or call it directly:

```sh
~/bin/hugo server --buildDrafts   # preview at http://localhost:1313
~/bin/hugo --gc --minify          # production build into public/
```

## Writing a post

```sh
~/bin/hugo new content blog/my-post-slug.md
```

Posts render at the root (`/my-post-slug/`), Bear Blog style. Set
`draft: false` in the front matter when ready.

## Diagrams (tldraw → SVG)

1. Draw the wireframe in tldraw Desktop and leave the document open on the
   page you want.
2. Export both colour schemes:

   ```sh
   scripts/export-diagram.sh <doc-name-substring> <slug>
   # e.g. scripts/export-diagram.sh fpl-season-lab fpl-season-lab
   ```

   This writes `static/diagrams/<slug>-light.svg` and `<slug>-dark.svg`.
3. Embed in a post with the `diagram` shortcode:

   ```markdown
   {{< diagram src="<slug>" alt="..." caption="..." >}}
   ```

   The shortcode serves the dark variant automatically to readers in dark mode.

Blog-owned diagram sources live in `diagrams/`. Diagrams belonging to the FPL
project stay canonical in the FPL repo (`docs/diagrams/`); export from there.

## Email list (Buttondown)

A quiet signup form appears at the end of posts (and in the footer elsewhere)
once you set a username. Useful for checking whether visitors convert.

1. Create a free [Buttondown](https://buttondown.com) account.
2. Copy your username from the Buttondown URL / embedding settings.
3. Set it in `hugo.yaml`:

   ```yaml
   params:
     newsletter:
       username: "your-username"
   ```

4. Redeploy. Conversion ≈ new subscribers / unique visitors over the same window
   (Cloudflare Web Analytics + Buttondown subscriber count is enough).

Leave `username` empty to keep the form hidden.

## Deployment (Cloudflare Pages)

1. Push this repo to GitHub.
2. Cloudflare Pages → *Create project* → connect the repo.
3. Build settings: command `hugo --gc --minify`, output directory `public`.
4. Set environment variable `HUGO_VERSION` to `0.164.0`.
5. Update `baseURL` in `hugo.yaml` to the `*.pages.dev` URL (or a custom
   domain from Cloudflare Registrar later).

## Daily content scout (Cursor Automation)

A scheduled Cloud Agent can scan this repo each day for new posts and team /
lineup notes, then open a PR with X drafts and blog outlines under
`content-ideas/`.

1. Open [Cursor Automations](https://cursor.com/automations).
2. Trigger: **Scheduled → daily** (or cron, e.g. `0 8 * * *` UTC).
3. Attach **this repository** on `main` (cron defaults to no repo — attach it).
4. Tools: pull request creation on; Memories on; optional Slack digest.
5. Prompt: paste [`.cursor/automations/daily-content-scout.md`](.cursor/automations/daily-content-scout.md).

The agent only opens a PR when something meaningful changed. X posts are
drafted for you to copy — Automations do not post to X natively. See
[`content-ideas/README.md`](content-ideas/README.md).
