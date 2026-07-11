# AGENTS.md — tech-blog-pub

> 面向 AI 编码/写作代理（Cursor、Copilot、OpenCode 等）。说明本仓库是什么、
> 目录约定，以及如何新增/维护一篇文章。任何代理读完本文件即可正确创建或更新文章。
>
> **Cursor 一键工作流**（新机器 bootstrap、写稿、sync、发布）：
> `.cursor/skills/rocpai-forge-blog/SKILL.md`

## 1. 本仓库是什么

`tech-blog-pub` 是**公开**的技术实践博客，也是**唯一来源（single source of truth）**。
每个主题同时维护**两个版本，共存于同一文件夹**：

- **精简版**（`README.md`）：~3 分钟中英双语摘要，面向 LinkedIn / X / 微信转发；
  读者快速知道"做了什么"，并通过文末项目引用动手复现。
- **技术详解版**（`README-details.md`）：完整工程细节——设计决策、算法/reward、
  训练曲线、诊断、复现命令、失败复盘。面向想深入与复现的工程读者。

> 历史：本仓库曾有一个私有的深度源仓库 `tech-blog`，现已退役。深度内容已并入本仓库
> 的 `README-details.md`，不再依赖任何私有仓库。

## 2. 目录约定

```
<category>/<post-slug>/
  README.md            # 精简版（GitHub 默认渲染 = 公开摘要）
  README-details.md    # 技术详解版（-details 后缀，与精简版共存）
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

## 3. 两版关系与互链

- 精简版顶部放一行指向详解版：`→ 技术详解版 / Deep-dive (README-details.md)`。
- 详解版顶部放一行指回精简版：`→ 精简版 / Concise digest (README.md)`。
- **实质一致**：环境、结果、数字两版必须一致，详解版只是更展开，绝不与精简版矛盾。

## 4. 新增一篇文章（代理工作流）

1. 选 `<category>` 与 `<slug>`，建 `<category>/<slug>/assets/{images,videos,gifs,code}/`。
2. 把图/短片/配置**拷贝进** `assets/`；媒体尽量压缩小。
3. 写 `README-details.md`（深度版）：H1 标题(zh) + 一行 en 副标题(blockquote) +
   语言切换锚点 + TL;DR；正文中文段落后接英文段落；相对路径内嵌媒体；含
   **复现（Reproduce）**章节与上游开源项目/PR 链接。
4. 写 `README.md`（精简版，~700–1000 词/语言）：同一故事的 3 分钟叙事版，少术语。
5. 两版顶部互加跳转链接（见 §3）。
6. 更新根 `README.md` 索引表：新增该文章 + 一句话摘要。
7. 提交并推送（见 §6）。

## 5. 风格

- 中英双语，同内容。
- **Evidence only**：每个量化结论都要能追溯到真实 run / 指标 / 图。
- 详解版展示失败与诊断，不只给最终结果。
- 数字/claim 两版一致；每个 CTA 必须公开可达（验证链接可解析）。

## 6. 发布（git/gh）

```bash
git add -A
git commit -m "blog(<slug>): <what changed>"
git push
```

- 本仓库 **PUBLIC**：只放公开安全内容；媒体自包含，不热链任何私有来源。

## 7. 同步到 Hugo 官网（rocPAI-Forge.github.io）

本仓库是**唯一内容源**，官网内容由脚本从这里**单向生成**（pub → Hugo），不要在
Hugo 仓库手写文章正文，否则会漂移。

> 职责划分：**本节(pub AGENTS.md)是发布流程与规则的权威来源**；**站点构建内部**
> （生成器实现、Hugo/PaperMod 版本锁、mermaid、CI/部署、i18n/默认语言）见官网仓库
> `README.md`：<https://github.com/rocPAI-Forge/rocPAI-Forge.github.io/blob/main/README.md>。
> llm-wiki 只留指针页,不记步骤。

**发布到官网 = 给该文件夹加一个 `meta.toml` sidecar**（只影响官网，不影响 GitHub 阅读）：

```toml
slug = "openarm-traj-gen"          # 官网 URL/文件名 slug(可与文件夹名不同)
date = 2026-06-30
author = "rocPAI-Lab: Alex He, David Li, Andy Luo"
tags = ["ROCm", "VLA", "OpenArm"]
title_zh = "中文标题"
title_en = "English title"
publish = true                      # false 或缺该文件 = 不上官网
```

- 官网**只发精简版** `README.md`；`README-details.md` 不重复上站，由官网文章内的
  链接指回本仓库。
- **发布规则(必守)**：每篇精简版站点文章必须在**正文显著位置**给出详解版入口——
  当前生成器在 **hero 之后(开头)** 放一条显著引导 **+ 文末兜底**，两处都链到本仓库对应的
  `README-details.md`。目的：让愿意多花时间的读者尽早切换到详解版。**不要移除**这条入口。
- 生成器（`rocPAI-Forge.github.io/scripts/sync_from_pub.py`）会：拆双语 → 套 front
  matter → 正文标题上提一级 → `assets/gifs/*.gif` 转循环 `<video>`(mp4+jpg 海报) →
  媒体落到 `static/media/<slug>/` → **开头 + 文末各插一个详解版入口**。
- 触发：`main` 分支上 `README.md` / `meta.toml` / `assets/**` 变化 →
  `.github/workflows/notify-site.yml` 通过 `repository_dispatch` 通知官网仓库重建。

### 一次性配置:SITE_DISPATCH_TOKEN

跨账户触发（本仓库 `alexhegit` → 官网 `rocPAI-Forge`）需要一个 PAT：

1. 建 PAT——classic 勾 `repo`，或 fine-grained 授权 `rocPAI-Forge/rocPAI-Forge.github.io`
   的 **Contents: Read and write**。
2. 本仓库 **Settings → Secrets and variables → Actions → New repository secret**，
   名字 `SITE_DISPATCH_TOKEN`，值填 PAT。

未配置该 secret 时 `notify-site.yml` 会显式失败并提示；官网仓库仍可用
`workflow_dispatch` 手动重建。
