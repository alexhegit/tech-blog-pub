# AGENTS.md — tech-blog-pub (public popular-science)

> This file is written for AI coding/writing agents (e.g. OpenClaw, Hermes,
> OpenCode, Cursor, Copilot). It explains what this repo is, how to author a
> short public post + social copy, and how it relates to the private deep-dive
> repo `tech-blog`. Any agent should be able to read this file and create or
> publish a post correctly.

## 1. What this repo is

`tech-blog-pub` is a **public**, popular-science companion blog. Posts are short,
story-driven, low-jargon retellings of a project, made for sharing on social media
(LinkedIn / X / WeChat) and for funneling curious readers toward hands-on,
open-source practice.

- **Audience**: broad / general technical readers (not specialists).
- **Visibility**: PUBLIC.
- **Read time target**: 3–5 minutes (~700–1000 words per language).
- **Tone**: narrative, accessible, light on math/jargon, visuals carry weight.

## 2. Companion repo & relationship

The private deep-dive source of truth is **`tech-blog`** (not public).

- `tech-blog` = full engineering depth (configs, curves, diagnostics, war stories).
- `tech-blog-pub` (here) = the **short, public** derivative for distribution.
- A post usually shares the **same `<category>/<slug>`** in both repos
  (e.g. `PhysicalAI/openarm-rl-grasp/`).

> CRITICAL — public reachability rules:
> - `tech-blog` is PRIVATE. **Never link to it** as a reader CTA, and **never
>   hotlink its raw asset URLs** (they 404 / don't render for the public).
> - This repo must be **self-contained**: copy any needed images/clips INTO this
>   post's `assets/`.
> - All "hands-on / reproduce" CTAs must point to **publicly accessible** targets
>   only (e.g. the upstream open-source project repo and its PRs).

## 3. Layout convention

```
<category>/<post-slug>/
  README.md            # the short post (bilingual: 中文 then English)
  assets/
    images/            # 1–3 key visuals only (copied, self-contained)
    videos/            # optional short clip(s)
  social/
    linkedin.md        # ready-to-paste LinkedIn post
    x-thread.md        # ready-to-paste X/Twitter thread
    wechat.md          # ready-to-paste WeChat copy (title + blurb + body)
```

- Reuse the SAME `<category>/<slug>` as the deep-dive post in `tech-blog`.
- Keep `assets/` lean — pick the 1–3 most compelling visuals, not everything.

## 4. How to derive a public post (agent workflow)

Given a deep-dive post (in `tech-blog`) or raw project notes:

1. Create `(<category>)/<slug>/assets/{images,videos}/` and `social/`.
2. Copy the 1–3 strongest visuals into `assets/` (do NOT hotlink the private repo).
3. Write `README.md` (3–5 min read):
   - H1 hook title (zh) + en subtitle; language switch + read-time line.
   - One lead image near the top.
   - 3–4 short beats max. Lead with the story/surprise, not the architecture.
   - Replace jargon with plain analogies; keep at most one or two named concepts.
   - End with a **"Want to try it yourself?"** CTA linking ONLY public repos
     (upstream OSS project + PR).
   - Bilingual: full 中文 section, then full English section.
4. Write the three `social/` files (see §5).
5. Update the root `README.md` index with the new post + one-liner.
6. Commit and push (see §6).

## 5. Social copy convention (`social/`)

- `linkedin.md`: a single post (~120–200 words), 1 image suggestion, a few
  hashtags, public CTA links. Optionally include a zh variant below.
- `x-thread.md`: a numbered thread (5–7 tweets), media notes per tweet, CTA in the
  last tweet, hashtags.
- `wechat.md`: title candidates + a <140-char blurb + a ~600-char Chinese body +
  public CTA links.
- All copy must funnel to PUBLIC targets only. No private links.

## 6. Publishing (git/gh)

```bash
# from the repo root
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

- Keep it short (3–5 min). If it grows deep, that content belongs in `tech-blog`.
- Self-contained assets only; never reference or hotlink the private repo.
- Every CTA must be publicly reachable — verify links resolve.
- Don't invent results; numbers/claims should match the deep-dive source.
