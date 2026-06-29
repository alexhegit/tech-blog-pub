# AGENTS.md — tech-blog-pub (public release of tech-blog)

> This file is written for AI coding/writing agents (e.g. OpenClaw, Hermes,
> OpenCode, Cursor, Copilot). It explains what this repo is, how to produce a
> **public, platform-ready release** of a `tech-blog` post, and how it relates to
> the private source repo `tech-blog`. Any agent should be able to read this file
> and release/update a post correctly.

## 1. What this repo is

`tech-blog-pub` is the **public release version of `tech-blog`**. It is NOT a
"popular-science" rewrite — **in principle it keeps the same content** as the
source post (same story, technical depth, results, figures, GIFs, sections). What
changes is **packaging / format**, optimized for publishing and distribution
across platforms (GitHub, LinkedIn, WeChat, X, …). If a piece is too long for a
channel, the content may be **trimmed — but only after explicit human approval**
(see the Content Sync Rule in §2).

- **Relationship to source**: faithful public mirror of a `tech-blog` post.
- **Content parity**: depth, numbers, and claims must match the source exactly.
- **Visibility**: PUBLIC.
- **Languages**: bilingual (中文 + English), same as the source.
- **What "format-optimized" means**: keep the content; adapt *presentation* to
  each platform's constraints, and ship ready-to-publish exports + social copy.

## 2. Companion repo & relationship

The source of truth is **`tech-blog`** (PRIVATE working repo).

- `tech-blog` (PRIVATE) = where the post is authored and iterated.
- `tech-blog-pub` (here, PUBLIC) = the **released, format-optimized** version of
  the same post.
- A post shares the **same `<category>/<slug>`** in both repos
  (e.g. `PhysicalAI/openarm-rl-grasp/`).

> CRITICAL — public reachability rules:
> - `tech-blog` is PRIVATE. **Never link to it** as a reader CTA, and **never
>   hotlink its raw asset URLs** (they 404 / don't render for the public).
> - This repo must be **self-contained**: copy any needed images/clips INTO this
>   post's `assets/`.
> - All "hands-on / reproduce" CTAs must point to **publicly accessible** targets
>   only (e.g. the upstream open-source project repo and its PRs).

> CONTENT SYNC RULE — content stays consistent with `tech-blog` **in principle**.
> When releasing/updating, the allowed edits are:
> - (a) **public-safety** (replace/strip private links, copy assets in, remove any
>   non-public references);
> - (b) **format optimization** for distribution on LinkedIn / WeChat / X / GitHub
>   (see §5) — this is encouraged and platform-specific;
> - (c) **length trimming** ONLY when the piece is too long for the target channel
>   — and ONLY after **explicit human approval**. The agent may *propose* concrete
>   cuts (and explain what/why), but must not trim autonomously.
>
> Never change results/numbers, and never silently drop technical depth. Format
> may change freely; meaning must not.

## 3. Layout convention

```
<category>/<post-slug>/
  README.md            # full public article (bilingual), content parity with tech-blog
  assets/
    images/            # figures copied in (self-contained)
    gifs/              # inline-playable animations (auto-play via ![]()) — preferred for motion
    videos/            # full-quality MP4 (HD download link; not inline on GitHub)
  social/
    linkedin.md        # ready-to-paste LinkedIn post (+ article notes)
    x-thread.md        # ready-to-paste X/Twitter thread
    wechat.md          # ready-to-paste WeChat copy (title + blurb + adapted body)
  publish/             # (optional) platform-ready exports (e.g. wechat-body, linkedin-article)
```

- Reuse the SAME `<category>/<slug>` as the source post in `tech-blog`.
- Assets are **copied in**, never hotlinked from the private repo.

## 4. How to release a post (agent workflow)

Given a source post in `tech-blog`:

1. Mirror the post: copy the source `README.md` + `assets/` into the same
   `<category>/<slug>/` here.
2. **Public-safety pass**: replace any private links, ensure all assets are local
   copies, confirm there are no `tech-blog` (private) hotlinks. CTAs → public only.
3. **Format-optimization pass** (§5): keep content identical; improve scannability
   and prepare platform exports.
4. Write the `social/` files (§6) and any `publish/` exports.
5. Update the root `README.md` index with the post + one-liner.
6. Commit and push (§7); verify public assets return `200`.

## 5. Format optimization (per platform)

The **GitHub README here is the canonical full article** (Markdown, inline GIFs,
tables, code blocks all render). Keep its content identical to the source; only
improve scannability: a TL;DR up top, bold takeaways, clear section anchors.

Other platforms do NOT support Markdown / code highlighting / tables / external
images the same way, so prepare adapted exports rather than pasting raw Markdown:

- **WeChat 公众号**: no Markdown or code highlighting; **blocks external images**
  (防盗链); GIF has size limits. → Provide an adapted Chinese body (e.g. via an
  mdnice-style converter), re-upload all images/GIFs to WeChat, turn tables into
  a simple list or an image, keep code snippets minimal (or as an image).
- **LinkedIn**: Article = rich text (no code highlight / no real tables); Post =
  plain text (~3000 chars), links are deprioritized in-body. → Code/tables as
  images or bullet lists; put the primary CTA link in the **first comment**, not
  the body; lead with a hook + one strong visual (GIF/image).
- **X/Twitter**: numbered thread, ~280 chars/tweet, one media per tweet. → Map
  beats to tweets, attach the GIF/figure per tweet, CTA in the last tweet.

Language targeting: prefer **one language per platform export** (English for
LinkedIn/X, Chinese for WeChat); the repo README stays bilingual.

Visuals carry distribution: lead with the strongest GIF/figure; consider turning
the key results **table** into a clean image so it survives platforms that don't
render Markdown tables.

## 6. Social copy convention (`social/`)

- `linkedin.md`: a single post (~150–250 words) + optional Article outline; one
  strong visual; a few hashtags; public CTA (link in first comment).
- `x-thread.md`: a numbered thread (6–9 tweets), per-tweet media notes, CTA in the
  last tweet, hashtags.
- `wechat.md`: title candidates + a <140-char blurb + an adapted Chinese body +
  public CTA links.
- All copy must funnel to PUBLIC targets only. No private links.

## 7. Publishing (git/gh)

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

## 8. Guardrails for agents

- **Content consistency** with `tech-blog` in principle: do not change results or
  silently drop technical depth.
- **Format** may be optimized freely for the target platform (LinkedIn / WeChat / X).
- **Length trimming** for over-long pieces is allowed ONLY after explicit human
  approval — propose cuts, don't apply them autonomously.
- Self-contained, public-safe assets only; never reference/hotlink the private repo.
- Numbers/claims must match the source post exactly.
- Every CTA must be publicly reachable — verify links resolve.
- Never let formatting (or approved trimming) alter the meaning.
