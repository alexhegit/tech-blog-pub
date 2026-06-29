# AGENTS.md — tech-blog-pub (public release of tech-blog)

> This file is written for AI coding/writing agents (e.g. OpenClaw, Hermes,
> OpenCode, Cursor, Copilot). It explains what this repo is, how to produce a
> **public, platform-ready release** of a `tech-blog` post, and how it relates to
> the private source repo `tech-blog`. Any agent should be able to read this file
> and release/update a post correctly.

## 1. What this repo is

`tech-blog-pub` is the **public release version of `tech-blog`** — a **concise,
~3-minute bilingual digest** of the source deep-dive, format-optimized for sharing
and reposting on LinkedIn / WeChat / X.

- **Consistent in substance** with `tech-blog`: same story, environment, results,
  and claims — never contradict or change the numbers.
- **Intentionally trimmed**: it does NOT reproduce every section/command/figure of
  the deep-dive. It keeps the essentials and points readers to the project to go
  deeper and reproduce.
- **Goal**: in ~3 minutes, tell readers *what was done* and *make them want to
  reproduce it* via the referenced open-source project.
- **Visibility**: PUBLIC. **Languages**: bilingual (中文 then English).

## 2. Companion repo & relationship

The source of truth is **`tech-blog`** (PRIVATE working repo).

- `tech-blog` (PRIVATE) = full engineering deep-dive (all sections, commands,
  curves, diagnostics, war stories).
- `tech-blog-pub` (here, PUBLIC) = the **concise public digest** of that post.
- A post shares the **same `<category>/<slug>`** in both repos
  (e.g. `PhysicalAI/openarm-rl-grasp/`).

> CRITICAL — public reachability rules:
> - `tech-blog` is PRIVATE. **Never link to it** as a reader CTA, and **never
>   hotlink its raw asset URLs** (they 404 / don't render for the public).
> - This repo must be **self-contained**: copy any needed images/GIFs INTO this
>   post's `assets/`.
> - All "reproduce / hands-on" references must point to **publicly accessible**
>   targets only (e.g. the upstream open-source project repo and its PRs).

> CONTENT RULE — the digest stays consistent with `tech-blog` in substance.
> Trimming for the ~3-min length is expected and pre-approved for this repo, BUT:
> never change results/numbers, and never contradict the source. If unsure whether
> a deeper cut is acceptable, propose it to a human first.

## 3. Layout convention

```
<category>/<post-slug>/
  README.md            # the concise bilingual digest (中文 then English)
  assets/
    gifs/              # inline-playable animations (auto-play via ![]()) — preferred for motion
    images/            # only the 1–2 most compelling figures, if any
```

- Reuse the SAME `<category>/<slug>` as the source post in `tech-blog`.
- Keep `assets/` **lean**: only the visuals actually embedded in the digest
  (typically 1–2 GIFs). Do not carry over unused figures/videos/code.
- No `social/` or `publish/` folders — the bilingual README *is* the deliverable;
  readers repost it manually to each platform.

## 4. Required structure of the digest (README.md)

H1 title (zh) + one-line en subtitle (blockquote) + a language switch line with a
`⏱️ ~3 min read` hint, then a `中文` section and an `English` section, each with:

1. **概要 / Overview** — what we did + the 1–2 most interesting outcomes, in a few
   sentences. Embed the single strongest GIF right after.
2. **实践环境 / Environment** — hardware (e.g. AMD Instinct MI300X/MI210), platform
   (e.g. ROCm + the one-line setup), and the framework (one-sentence identity).
3. **实践过程概要 + 关键命令 / What we did + key commands** — a short bulleted
   summary of the process, then only the **few key commands** (not every command).
4. **实践结果与结论 / Results & takeaways** — a compact results table or bullets,
   plus 2–3 takeaways.
5. **项目引用 / References** — links to the PUBLIC project + PR, framed as
   "reproduce it yourself".

Keep each language to roughly a 3-minute read. Lead with the story/surprise.

## 5. Format optimization (for reposting)

The GitHub README renders Markdown, inline GIFs, tables, and code blocks. When the
author manually reposts elsewhere, keep in mind (do NOT add per-platform files):

- **WeChat**: no Markdown/code highlighting; **blocks external images** (re-upload
  in the editor); tables may need to become a list/image; GIF has size limits.
- **LinkedIn**: rich-text article / plain-text post; code & tables don't render —
  use an image or bullets; put the primary link in the first comment.
- **X**: split into a short thread; one media per tweet.

Prefer leading with the strongest GIF/figure; numbers as a compact table.

## 6. Publishing (git/gh)

```bash
git add -A
git commit -m "blog(<category>): <what changed>"
git push
# new repo (first time only):
#   gh repo create <owner>/tech-blog-pub --public --source=. --remote=origin --push
```

- Do NOT change global git config / author identity.
- After pushing, verify any embedded asset renders publicly:
  `curl -s -o /dev/null -w "%{http_code}" https://raw.githubusercontent.com/<owner>/tech-blog-pub/main/<path>`
  (expect `200`).

## 7. Guardrails for agents

- Keep it a **~3-min digest**; deep detail belongs in `tech-blog`.
- Consistent with the source in substance; **never change results/numbers**.
- Self-contained, public-safe assets only; never reference/hotlink the private repo.
- Every reference/CTA must be publicly reachable — verify links resolve.
- Lean assets: only what the digest embeds.
