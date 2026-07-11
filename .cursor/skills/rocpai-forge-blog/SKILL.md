---
name: rocpai-forge-blog
description: >-
  Set up and maintain the rocPAI-Forge blog workflow: tech-blog-pub (content
  source) → sync_from_pub.py → rocPAI-Forge.github.io (Hugo site). Use when
  cloning the blog repos, writing or publishing posts, syncing to the site,
  local Hugo preview, or any rocPAI-Forge / tech-blog-pub blog task.
---

# rocPAI-Forge Blog Workflow

Project copy in this repo: `.cursor/skills/rocpai-forge-blog/SKILL.md`.
Symlink for Cursor: `ln -sf <path-to-this-repo>/.cursor/skills/rocpai-forge-blog ~/.cursor/skills/rocpai-forge-blog`

## Two Repos — Roles & Relationship

```
tech-blog-pub (SOURCE)          rocPAI-Forge.github.io (SITE)
rocPAI-Forge/tech-blog-pub →    rocPAI-Forge/rocPAI-Forge.github.io
                                
Write here. Never skip.         Generated + hand-written pages.
                                Do NOT hand-edit blog post bodies.
```

| Repo | Owner | Purpose |
|------|-------|---------|
| **tech-blog-pub** | `rocPAI-Forge` | **Single source of truth** for blog content. GitHub-readable bilingual posts + assets. |
| **rocPAI-Forge.github.io** | `rocPAI-Forge` | Hugo + PaperMod org site at https://rocpai-forge.github.io/. Blog posts are **generated** from pub. |

**Data flow (one direction only):**

```
pub README.md + meta.toml + assets/
        ↓  scripts/sync_from_pub.py
Hugo content/posts/<slug>.{zh,en}.md + static/media/<slug>/
        ↓  hugo build (CI or local)
https://rocpai-forge.github.io/
```

**Iron rule:** Edit blog content in **tech-blog-pub only**. Never hand-edit `content/posts/*.md` or `static/media/*` in the Hugo repo — the next sync overwrites them.

**Authority:** Content rules → `tech-blog-pub/AGENTS.md`. Site build internals → `rocPAI-Forge.github.io/README.md`.

---

## Bootstrap on a New Machine

### 1. Prerequisites

- `git`, `gh` (authenticated), `python3` (≥3.10), `ffmpeg`
- Optional local preview: Hugo **extended 0.148.2** (must match site CI)

### 2. Clone both repos (sibling layout)

```bash
WORK_DIR="${WORK_DIR:-$HOME/rocpai-forge}"
mkdir -p "$WORK_DIR" && cd "$WORK_DIR"

git clone https://github.com/rocPAI-Forge/tech-blog-pub.git
git clone https://github.com/rocPAI-Forge/rocPAI-Forge.github.io.git
```

SSH remotes work too if configured. Open **`$WORK_DIR`** (or both repos) in Cursor.

### 3. Verify

```bash
cd "$WORK_DIR/rocPAI-Forge.github.io"
python3 scripts/sync_from_pub.py --pub ../tech-blog-pub --out .
# expect: "done: N post(s): ..."
```

### 4. Optional: local preview

```bash
cd "$WORK_DIR/rocPAI-Forge.github.io"
hugo server -D    # http://localhost:1313/
```

One-shot bootstrap (from this repo after clone):

```bash
bash tech-blog-pub/.cursor/skills/rocpai-forge-blog/scripts/bootstrap.sh [WORK_DIR]
```

If you are already inside `tech-blog-pub`:

```bash
bash .cursor/skills/rocpai-forge-blog/scripts/bootstrap.sh [WORK_DIR]
```

---

## Post Folder Layout (tech-blog-pub)

```
PhysicalAI/<post-slug>/
  README.md            # Concise bilingual digest (~3 min) — published to site
  README-details.md    # Deep-dive — stays on GitHub, linked from site
  meta.toml            # Hugo publish metadata (sidecar)
  assets/
    images/  videos/  gifs/  code/
```

- Category today: `PhysicalAI`. Slug: kebab-case (e.g. `openarm-rl-grasp`).
- **One folder per topic** — concise + deep-dive share `assets/`. No `<slug>-details/` folder.
- All media referenced with relative paths inside `assets/`. Self-contained; no hotlinks.

### meta.toml template

```toml
slug = "my-post"              # site URL slug (can differ from folder name)
date = 2026-07-06
author = "rocPAI-Lab: Name"
tags = ["ROCm", "OpenArm"]    # use "ROCm" not "AMD ROCm"; omit "PhysicalAI"
title_zh = "中文标题"
title_en = "English title"
publish = true                # false = skip site generation
```

### README.md bilingual structure

```markdown
# 中文标题
> English subtitle

**语言 / Language:** [中文](#中文) · [English](#english)

> 📖 技术详解版 → [README-details.md](README-details.md)

![hero](assets/gifs/hero.gif)

---

## 中文
### 概要
...

---

## English
### Overview
...
```

- Numbers and claims must match between concise and deep-dive versions.
- Site publishes **concise only**; generator adds deep-dive links at top + footer.

---

## Workflows

### A. Edit an existing post

1. Edit `tech-blog-pub/PhysicalAI/<slug>/README.md` (and `README-details.md` if needed).
2. Update `meta.toml` if tags/titles/date change.
3. Commit & push pub:
   ```bash
   cd tech-blog-pub
   git add -A && git commit -m "blog(<slug>): <what changed>" && git push
   ```
4. Sync site (local or CI):
   ```bash
   cd ../rocPAI-Forge.github.io
   python3 scripts/sync_from_pub.py --pub ../tech-blog-pub --out .
   git add content/posts/ static/media/
   git commit -m "content(<slug>): sync from tech-blog-pub"
   git push
   ```

Push to pub triggers `notify-site.yml` → `repository_dispatch` to rebuild the site (needs `SITE_DISPATCH_TOKEN` secret on pub). Pushing the synced Hugo repo also triggers deploy.

### B. Add a new post

```
- [ ] Create PhysicalAI/<slug>/ with assets/{images,videos,gifs,code}/
- [ ] Write README-details.md (deep-dive, bilingual)
- [ ] Write README.md (concise, bilingual, ## 中文 / ## English)
- [ ] Add meta.toml with publish = true
- [ ] Update tech-blog-pub/README.md index table
- [ ] git push pub → sync → git push site
```

### C. Draft without publishing

Set `publish = false` in `meta.toml` (or omit the file). Generator skips the folder.

---

## Commit Conventions

| Repo | Message pattern | Example |
|------|-----------------|---------|
| tech-blog-pub | `blog(<slug>): …` | `blog(openarm-rl-grasp): add UniLab intro` |
| site (sync only) | `content(<slug>): sync from tech-blog-pub` | `content(openarm-rl-grasp): sync tags` |
| site (hand-written) | `content(overview): …` | overview/roadmap only |

Only commit when the user asks. Never hand-edit generated posts to "fix" content — fix pub source and re-sync.

---

## Tag Conventions (site)

- `AMD ROCm` → **`ROCm`**
- Omit **`PhysicalAI`** (org-wide theme, redundant as a tag)
- Prefer specific tags: `RL`, `VLA`, `OpenArm`, `UniLab`, etc.

---

## What Agents Must NOT Do

1. Hand-edit `rocPAI-Forge.github.io/content/posts/<slug>.*.md` for content changes.
2. Create blog content only in the Hugo repo.
3. Split deep-dive into a separate `-details/` folder.
4. Reference media outside the post's `assets/` directory.
5. Remove deep-dive entry links from generated site posts (generator owns this).

---

## Quick Reference

```bash
PUB=../tech-blog-pub          # from site repo root
SITE=../rocPAI-Forge.github.io

# Generate Hugo content
python3 scripts/sync_from_pub.py --pub "$PUB" --out .

# List published posts
grep -l 'publish = true' "$PUB"/PhysicalAI/*/meta.toml

# Live site
# https://rocpai-forge.github.io/en/posts/<slug>/
# https://rocpai-forge.github.io/zh/posts/<slug>/
```

## Additional Resources

- Full content rules: `AGENTS.md` (repo root)
- Site build & Hugo version lock: `rocPAI-Forge.github.io/README.md`
- `meta.toml` + README examples: `PhysicalAI/openarm-rl-grasp/`, `PhysicalAI/openarm-traj-gen-for-vla/`
