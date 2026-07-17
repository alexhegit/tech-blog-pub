# SO-101 SimStudio：在 AMD ROCm 上打开机器人物理 AI 之门

> SO-101 SimStudio: Opening the Door to Robot Physical AI on AMD ROCm

**语言 / Language:** [中文](#中文) · [English](#english) · 📄 技术详解版 / Deep-dive

> ⚡ 只想 3 分钟快速了解？ → [**精简版 / Concise digest**](README.md)

> TL;DR：[SO-101 SimStudio](https://github.com/alexhegit/so101-simstudio) 是面向 **Ubuntu 24.04 +
> AMD ROCm** 的 SO-101 MuJoCo 遥操作与 LeRobot v3.0 专家轨迹采集平台。v0.1.2 支持键盘 /
> Joy-Con / Leader 三种遥操作、MuJoCo / Rerun 双录制 GUI，且**不修改 LeRobot 上游**。
> 新读者从 [QUICKSTART.md](https://github.com/alexhegit/so101-simstudio/blob/main/QUICKSTART.md) 开始。

![项目介绍 / Project intro](assets/gifs/hero-intro.gif)

---

## 中文

### 0. 背景与动机

我和很多朋友一样，是从 **SO-101** 和 [**LeRobot**](https://github.com/huggingface/lerobot)
开始物理 AI 和机器人之旅的。SO-101（The Robot Studio 的开源 6-DOF 臂）加上 LeRobot 的数据集
与训练 pipeline，降低了「第一次让机械臂动起来、录数据、跑 BC」的门槛——这是非常好的入门项目。

同时我也是 **AMD ROCm** 开发者。在 Physical AI 里，**仿真**和真机同样重要：

- **低成本试错**：MuJoCo 物理引擎让你在 sim 里练遥操作、调场景、验证录制 pipeline，不必
  先买齐真机与相机。
- **数据引擎**：VLA / BC 模型需要大量 observation–action 示范；sim 内人类遥操作录制的专家
  轨迹，是连接「入门硬件」与「下游学习」的关键一环。
- **平台可达性**：若整条链路能在 **ROCm** 上跑通，开发者用 **AMD Ryzen AI 笔记本或 mini PC**
  就能开始，而不必绑定特定 GPU 生态。

LeRobot 生态里已有 SO-101 真机栈，但 **ROCm-first、开箱即用的 SO-101 MuJoCo 仿真采集工具**
仍缺一块拼图。SO-101 SimStudio 把 SO-101 资产、MuJoCo 仿真、LeRobot v3.0 格式与 ROCm 环境
整合在一起，让物理 AI 开发者能在 AMD 平台上**从仿真环境**入门机器人物理 AI。

> 项目会持续开发。本文描述 **v0.1.2**（tag `release-v0.1.2`）的能力与架构；后续 release
> 与专题实践会另发 blog。

### 1. 设计原则

摘自项目 [DESIGN.md](https://github.com/alexhegit/so101-simstudio/blob/main/DESIGN.md)：

1. **LeRobot 作 submodule，零修改** — 通过 `lerobot_robot_*` / `lerobot_teleoperator_*`
   插件发现接入，便于跟进上游版本。
2. **ROCm-first** — `make rocm-sync` + `uv` 管理依赖；Ubuntu 24.04 + ROCm 7.2.x 为当前
   支持矩阵（macOS / NVIDIA CUDA 在 ROADMAP 中）。
3. **模块化** — Robot 层、Teleop 层、Action Mapping、Scripts 分层清晰，便于加新后端。
4. **两种控制范式** — 速度（键盘、Joy-Con）与位置（Leader 臂），统一映射到 robot-native action。

### 2. 架构

![架构数据流](assets/images/architecture-flow.png)

```
┌─────────────────────────────────────────────────────────┐
│  LeRobot scripts (lerobot_record, lerobot_replay, …)    │
│  不修改上游                                               │
└─────────────────────────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────┐
│  插件发现: lerobot_robot_* / lerobot_teleoperator_*      │
└─────────────────────────────────────────────────────────┘
        ┌───────────────────┴───────────────────┐
        ▼                                       ▼
┌───────────────┐                       ┌─────────────────┐
│  Robot 层     │                       │  Teleop 层      │
│ so101_mujoco  │                       │ so101_keyboard  │
│ so101_real_   │                       │ so101_joycon    │
│ follower(规划)│                       │ so101_leader    │
└───────┬───────┘                       └────────┬────────┘
        │         ┌──────────────────┐           │
        └────────►│  Action Mapping  │◄──────────┘
                  └────────┬─────────┘
                           ▼
                  ┌─────────────────┐
                  │ robot.send_action│ → MuJoCo 步进 + 相机渲染
                  └─────────────────┘
                           ▼
                  LeRobot dataset v3.0（多 episode、可 resume）
```

**仿真场景：** `SO101/scenes/simple_pick/` — 桌面 + 可重置方块 + front / top / wrist 三路相机。

**录制 GUI（`--view_mode`）：**

| 模式 | 说明 |
| --- | --- |
| `mujoco`（默认） | GLFW 3D 窗口，遥操作延迟最低 |
| `rerun` | LeRobot Rerun 多相机流；Wayland / 部分 headless 工作流更友好 |

两种模式写入**相同**的 LeRobot v3.0 数据集；仅 live preview 不同。

### 2.1 Demo 视频与素材

项目 demo 视频 `SO101-SimStudio-Demo01.mp4`（约 27s，1080p）已截取为 blog 素材，存放在本帖
`assets/`：

| 素材 | 来源时间点 | 用途 |
| --- | --- | --- |
| `gifs/hero-intro.gif` + `videos/hero-intro.mp4` | 0–3s | 标题页 |
| `gifs/teleop-leader.gif` + `videos/teleop-leader.mp4` | 4.5–8.5s | Leader 臂 teleop |
| `gifs/teleop-joycon.gif` + `videos/teleop-joycon.mp4` | 9.5–13.5s | Joy-Con teleop |
| `gifs/teleop-keyboard.gif` + `videos/teleop-keyboard.mp4` | 12–16s | 键盘 teleop |
| `images/platform-ryzen-ai.jpg` | ~15s | Ryzen AI 平台展示 |
| `images/teleop-*.jpg` | 各段最佳静帧 | 文档 / 社交转发 |

三种 teleop 实拍对比：

| 键盘 | Joy-Con | Leader |
| --- | --- | --- |
| ![键盘 teleop](assets/gifs/teleop-keyboard.gif) | ![Joy-Con teleop](assets/gifs/teleop-joycon.gif) | ![Leader teleop](assets/gifs/teleop-leader.gif) |

> Hugo 官网 sync 时，`assets/gifs/*.gif` 会优先配对 `assets/videos/<同名>.mp4` 生成循环
> `<video>`；GitHub 上 gif 为静帧封面，mp4 提供动画源。

### 3. v0.1.2 功能清单

| 组件 | 状态 | 说明 |
| --- | --- | --- |
| MuJoCo SO-101 仿真 | ✅ | 6-DOF + 夹爪，`simple_pick` 场景 |
| 键盘遥操作 | ✅ | 世界系速度控制（WASD 等） |
| Joy-Con 遥操作 | ✅ | 柱坐标 reach/swing；单手 A/Y/+ 录制；左右手 |
| Leader 臂遥操作 | ✅ | Feetech STS3215，1:1 位置映射 |
| 录制 / 回放 / 校验 | ✅ | LeRobot v3.0；单集或多集 replay |
| MuJoCo 录制 GUI | ✅ | `--view_mode mujoco` |
| Rerun 录制 GUI | ✅ | `--view_mode rerun` |
| evdev 录制控制 | ✅ | 焦点无关：→/N 下一集，←/R 重录，ESC/Q 结束 |
| ROCm 环境 | ✅ | `make rocm-sync` |
| Smoke / quicktest | ✅ | `scripts/smoke/`、`scripts/quicktest/` |
| 真机 follower | 🔲 | ROADMAP |
| BC 训练 / 策略 rollout | 🔲 | ROADMAP |

**版本沿革（摘要）：**

- **v0.1.2** — Joy-Con 柱坐标与单手录制；joycon-robotics 上游 pin + install-time patch；`scripts/quicktest/`
- **v0.1.1** — 统一 `--view_mode`；evdev 录制控制；Leader 可靠性；smoke 脚本
- **v0.1.0** — 首个稳定 release；三种 teleop + record/replay/validate

### 4. 从哪里开始读文档

| 读者目标 | 文档 |
| --- | --- |
| **第一次安装并录一集数据** | [**QUICKSTART.md**](https://github.com/alexhegit/so101-simstudio/blob/main/QUICKSTART.md) ← **从这里开始** |
| 理解模块划分与 action 语义 | [DESIGN.md](https://github.com/alexhegit/so101-simstudio/blob/main/DESIGN.md) |
| 平台支持与未来计划 | [ROADMAP.md](https://github.com/alexhegit/so101-simstudio/blob/main/ROADMAP.md) |
| 开发 / Agent 约定 | [AGENTS.md](https://github.com/alexhegit/so101-simstudio/blob/main/AGENTS.md) |

### 5. 复现（Reproduce）

**环境：** Ubuntu 24.04，AMD GPU + ROCm 7.2.x，Python 3.12+。

```bash
git clone --recursive https://github.com/alexhegit/so101-simstudio.git
cd so101-simstudio
make rocm-sync
source .venv-rocm/bin/activate
```

**Smoke：**

```bash
make rocm-smoke-record
make smoke-keyboard-record VIEW_MODE=mujoco EPISODES=1
```

**键盘录制（MuJoCo GUI）：**

```bash
python -m simstudio.scripts.record \
    --config configs/so101_mujoco_keyboard.yaml \
    --view_mode mujoco
```

**Joy-Con（需额外 `make joycon-sync`）：**

```bash
python -m simstudio.scripts.record \
    --config configs/so101_mujoco_joycon.yaml \
    --view_mode mujoco
```

**Leader 臂：**

```bash
python -m simstudio.scripts.record \
    --config configs/so101_mujoco_leader.yaml \
    --view_mode mujoco
```

录制控制（全 teleop 通用，evdev）：**→ / N** 保存并下一集，**← / R** 重录，**ESC / Q** 结束。

配置模板见本帖 `assets/code/so101_mujoco_keyboard.yaml`（与仓库 `configs/` 同步拷贝）。

### 6. 鸣谢

SO-101 SimStudio 依赖并受益于以下开源项目（完整表格与许可证见仓库
[ACKNOWLEDGEMENTS.md](https://github.com/alexhegit/so101-simstudio/blob/main/ACKNOWLEDGEMENTS.md)）：

| 项目 | 角色 |
| --- | --- |
| [LeRobot](https://github.com/huggingface/lerobot) | 数据集 v3.0、record/replay、插件 API |
| [MuJoCo](https://github.com/google-deepmind/mujoco) | 物理仿真与渲染 |
| [PyTorch (ROCm)](https://github.com/pytorch/pytorch) | 相机渲染等 tensor 后端 |
| [SO-ARM100 / SO-101](https://github.com/TheRobotStudio/SO-ARM100) | 开源臂设计与 mesh/URDF  lineage |
| [joycon-robotics](https://github.com/box2ai-robotics/joycon-robotics) | Joy-Con HID（可选） |
| [Rerun](https://github.com/rerun-io/rerun) | `--view_mode rerun` 与 `dataset_viz` |
| [python-evdev](https://github.com/gvalkov/python-evdev) | 焦点无关录制快捷键 |

### 7. 给开发者的实践建议

1. **Clone 并跑通 smoke** — 确认 ROCm 与 MuJoCo 窗口正常。
2. **录 2–3 个 keyboard episode** — 熟悉 evdev 控制与数据集目录结构。
3. **回放与可视化** — `replay` 脚本或 `dataset_viz`，检查相机与 action 对齐。
4. **换 teleop 对比** — 若有 Joy-Con 或 Leader，体会速度 vs 位置范式差异。
5. **关注 ROADMAP** — 真机 follower 与 BC 训练落地后，sim→real 链路会在此项目延伸。

欢迎 [Issue / PR](https://github.com/alexhegit/so101-simstudio/issues) 与社区反馈。

- **仓库**：[github.com/alexhegit/so101-simstudio](https://github.com/alexhegit/so101-simstudio)
- **精简版**：[README.md](README.md)

---

## English

### 0. Background & motivation

Like many in this community, I started with **SO-101** and [**LeRobot**](https://github.com/huggingface/lerobot). The open SO-101 arm plus LeRobot's dataset and training pipeline lower the bar for "first motion, first dataset, first BC run" — an excellent on-ramp.

As an **AMD ROCm** developer, I care equally about **simulation** in physical AI:

- **Cheap iteration** — MuJoCo lets you teleoperate, tune scenes, and validate recording pipelines before buying full hardware.
- **Data engine** — VLA / BC models need large demonstration corpora; human teleop in sim bridges entry-level hardware and downstream learning.
- **Platform reach** — a ROCm-native stack means an **AMD Ryzen AI laptop or mini PC** can be enough to start, without locking to one GPU vendor.

LeRobot already covers real SO-101 stacks; **ROCm-first, turnkey SO-101 MuJoCo collection** was the missing piece. SO-101 SimStudio integrates SO-101 assets, MuJoCo, LeRobot v3.0, and ROCm tooling so developers can learn robot physical AI **from simulation on AMD platforms**.

> Active development continues. This post documents **v0.1.2** (`release-v0.1.2`); future releases and practice posts will follow.

### 1. Design principles

From [DESIGN.md](https://github.com/alexhegit/so101-simstudio/blob/main/DESIGN.md):

1. **LeRobot as submodule, zero patches** — plugin discovery via `lerobot_robot_*` / `lerobot_teleoperator_*`.
2. **ROCm-first** — `make rocm-sync` + `uv`; Ubuntu 24.04 + ROCm 7.2.x supported today.
3. **Modular layers** — robot, teleop, action mapping, scripts.
4. **Two control paradigms** — velocity (keyboard, Joy-Con) vs position (leader), mapped to robot-native actions.

### 2. Architecture

![Architecture data flow](assets/images/architecture-flow.png)

LeRobot record/replay scripts sit on top; SimStudio registers `so101_mujoco` and teleop plugins; action mapping converts teleop output to `robot.send_action()`; MuJoCo steps physics and renders cameras into **LeRobot dataset v3.0**.

**Scene:** `SO101/scenes/simple_pick/` — table, resettable cube, front / top / wrist cameras.

**Recording GUI (`--view_mode`):** `mujoco` (GLFW, lowest teleop latency) or `rerun` (multi-camera, Wayland-friendly). Same dataset either way.

### 2.1 Demo video assets

Demo clip `SO101-SimStudio-Demo01.mp4` (~27s, 1080p) was sliced into this post's `assets/`:

| Asset | Source time | Purpose |
| --- | --- | --- |
| `gifs/hero-intro.gif` + `videos/hero-intro.mp4` | 0–3s | Title card |
| `gifs/teleop-leader.gif` + `videos/teleop-leader.mp4` | 4.5–8.5s | Leader teleop |
| `gifs/teleop-joycon.gif` + `videos/teleop-joycon.mp4` | 9.5–13.5s | Joy-Con teleop |
| `gifs/teleop-keyboard.gif` + `videos/teleop-keyboard.mp4` | 12–16s | Keyboard teleop |
| `images/platform-ryzen-ai.jpg` | ~15s | Ryzen AI platform shot |

Three teleop modes side by side:

| Keyboard | Joy-Con | Leader |
| --- | --- | --- |
| ![Keyboard teleop](assets/gifs/teleop-keyboard.gif) | ![Joy-Con teleop](assets/gifs/teleop-joycon.gif) | ![Leader teleop](assets/gifs/teleop-leader.gif) |

### 3. v0.1.2 feature matrix

| Component | Status | Notes |
| --- | --- | --- |
| MuJoCo SO-101 sim | ✅ | 6-DOF + gripper, `simple_pick` |
| Keyboard teleop | ✅ | World-frame velocity |
| Joy-Con teleop | ✅ | Cylindrical reach/swing; one-handed record buttons |
| Leader arm teleop | ✅ | Feetech STS3215 position mapping |
| Record / replay / validate | ✅ | LeRobot v3.0 |
| MuJoCo / Rerun recording GUI | ✅ | `--view_mode mujoco \| rerun` |
| evdev recording controls | ✅ | Focus-independent hotkeys |
| ROCm environment | ✅ | `make rocm-sync` |
| Real follower / BC training | 🔲 | ROADMAP |

### 4. Which doc to read first

| Goal | Doc |
| --- | --- |
| **Install and record your first episode** | [**QUICKSTART.md**](https://github.com/alexhegit/so101-simstudio/blob/main/QUICKSTART.md) ← **start here** |
| Architecture & action semantics | [DESIGN.md](https://github.com/alexhegit/so101-simstudio/blob/main/DESIGN.md) |
| Platform matrix & plans | [ROADMAP.md](https://github.com/alexhegit/so101-simstudio/blob/main/ROADMAP.md) |

### 5. Reproduce

**Environment:** Ubuntu 24.04, AMD GPU + ROCm 7.2.x, Python 3.12+.

```bash
git clone --recursive https://github.com/alexhegit/so101-simstudio.git
cd so101-simstudio
make rocm-sync
source .venv-rocm/bin/activate

make smoke-keyboard-record VIEW_MODE=mujoco EPISODES=1

python -m simstudio.scripts.record \
    --config configs/so101_mujoco_keyboard.yaml \
    --view_mode mujoco
```

Config snapshot: `assets/code/so101_mujoco_keyboard.yaml`.

Recording hotkeys (evdev, all teleops): **→ / N** next episode, **← / R** re-record, **ESC / Q** quit.

### 6. Acknowledgements

See [ACKNOWLEDGEMENTS.md](https://github.com/alexhegit/so101-simstudio/blob/main/ACKNOWLEDGEMENTS.md) for the full list and licenses. Core dependencies: LeRobot, MuJoCo, PyTorch (ROCm), SO-ARM100/SO-101, joycon-robotics, Rerun, python-evdev.

### 7. Suggested practice path

1. Clone and pass smoke tests.
2. Record 2–3 keyboard episodes; inspect dataset layout.
3. Replay / `dataset_viz` — check camera–action alignment.
4. Try another teleop backend if available.
5. Watch the ROADMAP for real follower and BC training.

- **Repo:** [github.com/alexhegit/so101-simstudio](https://github.com/alexhegit/so101-simstudio)
- **Concise digest:** [README.md](README.md)
