---
name: rocpai-forge-blog
description: >-
  rocPAI-Forge blog workflow (tech-blog-pub → Hugo site). Use for blog tasks in
  this repo. All rules and publish steps live in AGENTS.md at repo root — read that
  file first; this skill only adds Cursor bootstrap convenience.
---

# rocPAI-Forge Blog (Cursor skill)

**Authority:** [`AGENTS.md`](../../../AGENTS.md) at the tech-blog-pub repo root.
Read **only** that file for content rules, meta.toml, publish/sync workflows, and
commit conventions. Do not depend on any file outside tech-blog-pub.

## Cursor-only: bootstrap on a new machine

```bash
# from tech-blog-pub root
bash .cursor/skills/rocpai-forge-blog/scripts/bootstrap.sh [WORK_DIR]
```

Clones `rocPAI-Forge/tech-blog-pub` + `rocPAI-Forge/rocPAI-Forge.github.io` as siblings,
runs `sync_from_pub.py` once. See `AGENTS.md` §6 for manual steps and §8 for publish.

Optional symlink so Cursor discovers this skill globally:

```bash
ln -sf "$(pwd)/.cursor/skills/rocpai-forge-blog" ~/.cursor/skills/rocpai-forge-blog
```
