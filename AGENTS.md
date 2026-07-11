# AGENTS.md — tech-blog-pub

> 面向 AI 编码/写作代理（Cursor、Copilot、OpenCode 等）。**读完本文件即可**完成写稿、
> 提交与本仓库相关的全部发布操作；无需阅读本仓库外的任何文档或 skill 文件。

## 1. 本仓库是什么

`tech-blog-pub` 是**公开**的技术实践博客，也是**唯一内容来源（single source of truth）**。
每个主题同时维护**两个版本，共存于同一文件夹**：

- **精简版**（`README.md`）：~3 分钟中英双语摘要，面向 LinkedIn / X / 微信转发；
  读者快速知道"做了什么"，并通过文末项目引用动手复现。
- **技术详解版**（`README-details.md`）：完整工程细节——设计决策、算法/reward、
  训练曲线、诊断、复现命令、失败复盘。面向想深入与复现的工程读者。

> 历史：本仓库曾有一个私有的深度源仓库 `tech-blog`，现已退役。深度内容已并入本仓库
> 的 `README-details.md`，不再依赖任何私有仓库。

### 与官网仓库的关系

博客内容只在本仓库编写；官网 [rocpai-forge.github.io](https://rocpai-forge.github.io/)
由 Hugo 站点仓库 **`rocPAI-Forge/rocPAI-Forge.github.io`** 生成并部署。

```
tech-blog-pub (本仓库, SOURCE)     rocPAI-Forge.github.io (SITE)
只在这里写。不可跳过。              博文正文由脚本生成，禁止手改。
```

**单向数据流：**

```
<category>/<slug>/README.md + meta.toml + assets/
        ↓  rocPAI-Forge.github.io/scripts/sync_from_pub.py
Hugo content/posts/<slug>.{zh,en}.md + static/media/<slug>/
        ↓  Hugo build（CI 或本地）
https://rocpai-forge.github.io/zh/posts/<slug>/
https://rocpai-forge.github.io/en/posts/<slug>/
```

**铁律：** 博文内容只在 **tech-blog-pub** 修改。禁止在 Hugo 仓库手改
`content/posts/*.md` 或 `static/media/*` 来"修正文"——下次 sync 会覆盖。

## 2. 目录约定

```
<category>/<post-slug>/
  README.md            # 精简版（GitHub 默认渲染 = 公开摘要；官网上站）
  README-details.md    # 技术详解版（-details 后缀，与精简版共存；不上站）
  meta.toml            # 官网上站元数据（sidecar；缺省或 publish=false 则不上站）
  assets/              # 两版共享，素材只存一份
    images/            # 图（曲线、截图、示意图）— 相对路径内嵌
    videos/            # 短视频
    gifs/              # 循环动图
    code/              # 被引用的配置/片段（拷贝，不软链）
```

- `<category>` 按技术方向分组（当前：`PhysicalAI`）。
- `<post-slug>` 短横线命名（如 `openarm-traj-gen-for-vla`）。
- **同一主题一个文件夹**：精简版与详解版共用 `assets/`，**严禁**为详解版另建
  `<slug>-details/` 文件夹（会导致素材重复与漂移）。
- 每篇**自包含**：所有引用媒体放本文件夹 `assets/` 下，相对路径引用
  `![alt](assets/images/foo.png)`，不引用文件夹外文件。

**范例：** `PhysicalAI/openarm-rl-grasp/`、`PhysicalAI/openarm-traj-gen-for-vla/`。

### meta.toml（官网上站 sidecar）

```toml
slug = "openarm-traj-gen"          # 官网 URL slug（可与文件夹名不同）
date = 2026-06-30
author = "rocPAI-Lab: Alex He, David Li, Andy Luo"
tags = ["ROCm", "VLA", "OpenArm"]  # 见 §5 标签约定
title_zh = "中文标题"
title_en = "English title"
publish = true                      # false 或缺该文件 = 不上官网
```

### README.md 精简版结构（模版）

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

## 3. 两版关系与互链

- 精简版顶部放一行指向详解版：`→ 技术详解版 / Deep-dive (README-details.md)`。
- 详解版顶部放一行指回精简版：`→ 精简版 / Concise digest (README.md)`。
- **实质一致**：环境、结果、数字两版必须一致，详解版只是更展开，绝不与精简版矛盾。
- 官网**只发精简版** `README.md`；`README-details.md` 留在 GitHub，由站点文章内链接指回
  本仓库对应路径。

## 4. 风格与标签

### 写作风格

- 中英双语，同内容。
- **Evidence only**：每个量化结论都要能追溯到真实 run / 指标 / 图。
- 详解版展示失败与诊断，不只给最终结果。
- 数字/claim 两版一致；每个 CTA 必须公开可达（验证链接可解析）。

### 官网标签约定（`meta.toml` 的 `tags`）

- `AMD ROCm` → **`ROCm`**
- 省略 **`PhysicalAI`**（组织级主题，作 tag 冗余）
- 优先具体标签：`RL`、`VLA`、`OpenArm`、`UniLab` 等

## 5. 代理禁止事项

1. 在 Hugo 仓库手改 `content/posts/<slug>.*.md` 来改正文——应改本仓库后 re-sync。
2. 只在 Hugo 仓库创建博文内容。
3. 为详解版单独建 `<slug>-details/` 文件夹。
4. 引用本帖 `assets/` 目录外的媒体。
5. 试图移除生成器插入的详解版入口链接（生成器在 hero 后 + 文末各插一条）。
6. 直接 `git push origin main`（`main` 仅允许 PR merge）。

## 6. 新机器准备（首次发布前）

### 依赖

- `git`、`gh`（已登录）、`python3`（≥3.10）、`ffmpeg`（生成器转 gif 用）
- 可选本地预览：Hugo **extended 0.148.2**

### Clone 两个仓库（建议 sibling 布局）

```bash
WORK_DIR="${WORK_DIR:-$HOME/rocpai-forge}"
mkdir -p "$WORK_DIR" && cd "$WORK_DIR"

git clone https://github.com/rocPAI-Forge/tech-blog-pub.git
git clone https://github.com/rocPAI-Forge/rocPAI-Forge.github.io.git
```

SSH remote 亦可。已 clone 本仓库时，一键脚本：

```bash
bash .cursor/skills/rocpai-forge-blog/scripts/bootstrap.sh [WORK_DIR]
```

### 验证 sync

```bash
cd "$WORK_DIR/rocPAI-Forge.github.io"
python3 scripts/sync_from_pub.py --pub ../tech-blog-pub --out .
# 期望输出: done: N post(s): ...
```

### 可选：本地预览官网

```bash
cd "$WORK_DIR/rocPAI-Forge.github.io"
hugo server -D    # http://localhost:1313/
```

## 7. 工作流

### A. 新增一篇文章

1. 选 `<category>` 与 `<slug>`，建 `<category>/<slug>/assets/{images,videos,gifs,code}/`。
2. 把图/短片/配置**拷贝进** `assets/`；媒体尽量压缩小。
3. 写 `README-details.md`（深度版）：H1 标题(zh) + 一行 en 副标题(blockquote) +
   语言切换锚点 + TL;DR；正文中文段落后接英文段落；相对路径内嵌媒体；含
   **复现（Reproduce）**章节与上游开源项目/PR 链接。
4. 写 `README.md`（精简版，~700–1000 词/语言）：同一故事的 3 分钟叙事版，少术语（结构见 §2）。
5. 两版顶部互加跳转链接（见 §3）。
6. 添加 `meta.toml`，`publish = true`（要上官网时）。
7. 更新根 `README.md` 索引表：新增该文章 + 一句话摘要。
8. **发布**：分支 commit → PR → merge `main`（见 §8）。

### B. 修改已有文章

1. 编辑 `PhysicalAI/<slug>/README.md`（及 `README-details.md` 如需要）。
2. 若 tags / 标题 / 日期变化，更新 `meta.toml`。
3. **发布**：分支 commit → PR → merge `main`（见 §8）。

### C. 草稿（不上官网）

`meta.toml` 设 `publish = false`，或省略 `meta.toml`。生成器跳过该文件夹。

## 8. 发布

发布分两步：**PR 合并到 `main`** → **同步并 push 官网仓库**（或由 CI 自动触发第二步）。

`main` 已启用 **branch protection**：禁止直接 push，所有内容变更必须 **分支 → PR → merge**。

### 8.1 提交内容源（本仓库，经 PR）

```bash
cd tech-blog-pub
git checkout -b blog/<slug>-<short-desc>    # 例: blog/openarm-rl-grasp-unilab

git add -A
git commit -m "blog(<slug>): <what changed>"

git push -u origin HEAD
gh pr create --base main --title "blog(<slug>): <what changed>" --body "…"
# 或于 GitHub 网页创建 PR；维护者 review 后 merge
```

- 本仓库 **PUBLIC**：只放公开安全内容；媒体自包含，不热链任何私有来源。
- Commit / PR 标题格式：`blog(<slug>): …`，例：`blog(openarm-rl-grasp): add UniLab intro`
- **Merge 到 `main` 后**才触发官网自动重建（§8.2 方式一）；PR 打开期间不会发站。
- Agent：**不要** `git push origin main`；在用户确认后 push 分支并协助开 PR。

### 8.2 同步到 Hugo 官网

**方式一 — 自动（推荐，已配置 token 时）**

`main` 上 `README.md` / `meta.toml` / `assets/**` 变化后，
`.github/workflows/notify-site.yml` 通过 `repository_dispatch` 通知
`rocPAI-Forge.github.io` 拉取本仓库、跑 sync、部署。

需一次性配置 secret **`SITE_DISPATCH_TOKEN`**（见 §8.3）。未配置时 workflow 会
warning 并跳过，改用方式二。

**方式二 — 手动 sync + push**

```bash
cd rocPAI-Forge.github.io
python3 scripts/sync_from_pub.py --pub ../tech-blog-pub --out .
git add content/posts/ static/media/
git commit -m "content(<slug>): sync from tech-blog-pub"
git push
```

- 官网仓库 commit 格式：`content(<slug>): sync from tech-blog-pub`
- 从 Hugo 仓库根目录：`python3 scripts/sync_from_pub.py --pub ../tech-blog-pub --out .`

**生成器行为（`sync_from_pub.py`）：** 拆双语 → 套 front matter → 正文标题上提一级 →
`assets/gifs/*.gif` 转循环 `<video>`(mp4+jpg 海报) → 媒体落到 `static/media/<slug>/` →
**开头 + 文末各插一个详解版入口**（链到本仓库 `README-details.md` 的 GitHub blob URL）。

**发布规则(必守)：** 每篇站点文章必须在正文显著位置保留详解版入口；生成器负责插入，
代理不要试图删除或绕过。

### 8.3 一次性配置：SITE_DISPATCH_TOKEN

跨仓库触发（`tech-blog-pub` → `rocPAI-Forge.github.io`，同 org 下仍需 PAT）：

1. 建 PAT——classic 勾 `repo`，或 fine-grained 授权 `rocPAI-Forge/rocPAI-Forge.github.io`
   的 **Contents: Read and write**。
2. 本仓库 **Settings → Secrets and variables → Actions → New repository secret**，
   名字 `SITE_DISPATCH_TOKEN`，值填 PAT。

未配置时可用方式二手动 sync；或在 `rocPAI-Forge.github.io` 用 `workflow_dispatch` 手动重建。

## 9. 速查

```bash
# 列出已标记上站的文章
grep -l 'publish = true' PhysicalAI/*/meta.toml

# 发布本仓库（main 受保护，走 PR）
git checkout -b blog/<slug>-<desc>
git add -A && git commit -m "blog(<slug>): …"
git push -u origin HEAD && gh pr create --base main --fill

# 从 Hugo 仓库根目录生成内容
python3 scripts/sync_from_pub.py --pub ../tech-blog-pub --out .

# 线上地址
# https://rocpai-forge.github.io/zh/posts/<slug>/
# https://rocpai-forge.github.io/en/posts/<slug>/
```

| 仓库 | Commit 前缀 | 示例 |
|------|-------------|------|
| tech-blog-pub | `blog(<slug>): …` | `blog(openarm-rl-grasp): add UniLab intro` |
| 官网（仅 sync） | `content(<slug>): sync from tech-blog-pub` | `content(openarm-rl-grasp): sync tags` |
| 官网（手写页） | `content(overview): …` | overview/roadmap 等非博文页面 |

仅在用户要求时提交 commit 并开 PR。发现站点正文有误时，改本仓库源文件后 re-sync，不要手改生成结果。

## 10. 仓库权限与贡献

本仓库 **public 可读**。内容变更统一走 **PR → merge `main`**（branch protection 已启用）。

### 10.1 权限与流程

| 身份 | 读 | 直接 push `main` | 开 PR / push 分支 | 合并 PR |
|------|----|------------------|-------------------|---------|
| 公众 | ✅ | ❌ | fork 后 ✅ | ❌ |
| 无写权限的 org 成员 | ✅ | ❌ | ❌ | ❌ |
| 仓库 Write 维护者 | ✅ | ❌ | ✅ | ✅（经 review 后） |

**原则：**

- 所有博文改动：**分支上 commit → 开 PR → merge**，不直推 `main`。
- 外部贡献：**fork → PR**；不要给外部个人 Write。
- Agent 代写时使用维护者凭证 push **分支**，由维护者 merge PR。

### 10.2 维护者日常流程

```
git checkout -b blog/<slug>-<desc>
# 写稿、commit
git push -u origin HEAD
gh pr create --base main …
# review（若规则要求 approval）→ Merge pull request
# → notify-site.yml 触发官网重建（§8.2）
```

### 10.3 与官网发布的关系

- **Merge 到 `main`** 后，[`.github/workflows/notify-site.yml`](.github/workflows/notify-site.yml)
  在 `README.md` / `meta.toml` / `assets/**` 有变化时，通过 `repository_dispatch` 通知
  Hugo 站点重建（需 `SITE_DISPATCH_TOKEN`，见 §8.3）。
- 能 merge `main` 的维护者 ≈ 能间接触发官网更新；merge 前确认内容可公开。
- `SITE_DISPATCH_TOKEN` 建议用 fine-grained PAT 或 bot 账号，只授权
  `rocPAI-Forge/rocPAI-Forge.github.io` 的 Contents RW。

### 10.4 外部贡献

1. Fork `rocPAI-Forge/tech-blog-pub`
2. 在 fork 上按 §2–§7 写稿
3. 向 `main` 提 PR；维护者 review 后 merge
4. Merge 后确认官网 sync / CI 已完成（§8）

### 10.5 CODEOWNERS（可选）

[`.github/CODEOWNERS`](.github/CODEOWNERS) 列出默认 reviewer，便于 PR 自动 @ 维护者。
未在 branch protection 中强制「Require review from Code Owners」时，仅作提示，不阻塞合并。

