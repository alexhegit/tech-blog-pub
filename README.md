# tech-blog-pub

技术实践笔记的**公开仓库（唯一来源）**。每个主题维护两个共存版本：**精简版**
（`README.md`，~3 分钟中英双语，面向 LinkedIn / X / 微信转发）与**技术详解版**
（`README-details.md`，完整工程细节与复现）。读者可快速了解，也可深入复现。

The public home (single source of truth) for my engineering practice notes. Each topic
keeps two coexisting versions: a **concise** `README.md` (~3-min bilingual digest for
LinkedIn / X / WeChat) and a **deep-dive** `README-details.md` (full engineering detail
and reproduction). See `AGENTS.md` for the authoring convention.

## PhysicalAI

| 文章 / Post | 一句话 / One-liner |
| --- | --- |
| [openarm-rl-grasp](PhysicalAI/openarm-rl-grasp/) （[详解](PhysicalAI/openarm-rl-grasp/README-details.md) · 精简版待补） | 我们教机械臂捡方块，它却自己发明了一种我们没教的抓法。 / We taught a robot arm to pick up a cube — and it invented a grip we never taught it. |
| [openarm-traj-gen-for-vla](PhysicalAI/openarm-traj-gen-for-vla/) （[精简](PhysicalAI/openarm-traj-gen-for-vla/README.md) · [详解](PhysicalAI/openarm-traj-gen-for-vla/README-details.md)） | 在 AMD ROCm 上把 OpenArm 的抓-放变成一台"专家轨迹数据引擎"，为 VLA 训练批量造数据。 / On AMD ROCm, turning OpenArm pick-and-place into an "expert trajectory data engine" that mass-produces data for VLA training. |
