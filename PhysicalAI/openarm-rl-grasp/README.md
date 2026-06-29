# 当机械臂自己发明了一种抓法：在 UniLab 上做 OpenArm 抓取的强化学习实践

> When a Robot Arm Invents Its Own Grip: A Reinforcement Learning Practice on UniLab

**语言 / Language:** [中文](#中文) · [English](#english) ·  ⏱️ ~3 min read

---

## 中文

### 概要

我们在开源框架 [UniLab](https://github.com/unilabsim/UniLab) 上，用 PPO 给 **OpenArm**
单臂训练了一个"把方块抓起、抬到空中目标点并稳定保持"的策略。过程中最有意思的两件事：

1. 我们想让它"夹紧"，它却**自己发明了一种"开指托举"**——几乎不闭合手指，用两根指尖把
   方块兜住抬起，对这个高摩擦小方块反而更鲁棒。
2. 一条训练曲线（`action std`）一路**失控涨到 39**，我们用**一个超参**把它压回 1.35，
   曲线变干净、成功率还略升。

最终确定性评估：**ever success 100%、final success 87.9%、掉落率 0%**。

![总览回放](assets/gifs/play_overview.gif)

### 实践环境

- **硬件**：AMD Instinct **MI300X / MI210** GPU
- **平台**：**ROCm**——UniLab 一等支持，`make sync-rocm` 一键切换并安装依赖
- **框架**：[UniLab](https://github.com/unilabsim/UniLab)，一个 **CPU 物理仿真 + GPU 策略
  训练**的异构机器人 RL 框架（MuJoCo / Motrix 后端，配置驱动，统一 CLI）

```
┌───────────────────┐                            ┌─────────────────────────┐
│   CPU 物理仿真     │       统一共享内存          │     GPU 策略训练         │
│   MuJoCo/Motrix   │ ─────────────────────────▶ │     PPO / SAC / TD3      │
└───────────────────┘     SharedReplayBuffer      │  CUDA / MPS / ROCm / XPU │
                                                  └─────────────────────────┘
```

### 实践过程概要

- **从一键夹爪到连续夹爪**：先用 binary（瞬间闭合）夹爪跑通，再换成策略**连续控制**的
  夹爪，并设计分阶段抓取塑形（先在方块上方张开 → 下探 → 闭合 → 抬起）。
- **意外的"开指托举"**：评估发现手指闭合度 ≈ 0 却能 100% 抬起——RL 解的是它发现的、更
  好解的那道题，而不是我们出的题。
- **调干净失控曲线**：`action std` 失控是因为动作经 tanh 饱和后，增大噪声不损 reward，
  PPO 便一路薅熵奖励。把 `entropy_coef` 从 `0.01` 降到 `0.003` 即可（仅新增一个 owner
  变体 YAML，不改 Python）。

关键命令（完整流程见项目仓库）：

```bash
make sync-rocm          # 安装 ROCm 环境
# 训练
uv run train --algo ppo --task openarm_demo_pick --sim mujoco --profile lift3d_contgrip_lowent
# 确定性评估
uv run scripts/eval_openarm_success.py task=openarm_demo_pick/mujoco_lift3d_contgrip_lowent \
  algo.load_run=<your_run> +training.eval_envs=512
```

![左臂右前方特写：开指托举的细节](assets/gifs/play_closeup_leftfront.gif)

### 实践结果与结论

| 指标 | baseline `0.01` | 调参后 `0.003` |
| --- | --- | --- |
| ever success（512-env 确定性 eval） | 98.8% | **100.0%** |
| final success | 86.3% | **87.9%** |
| drop rate | 0% | 0% |
| 最终 `action std` | 39.08 | **1.35** |

三条带得走的经验：

1. **配置优先**：把"想法"写成配置而非代码，对照实验廉价又可追溯。
2. **盯住每一条曲线**：成功率没退化 ≠ 一切正常，失控的 `action std` 就藏在背后。
3. **让证据说话**：策略学出"开指托举"不是 bug，是更优解——先理解，再判断。

### 项目引用 / 动手复现

- 框架与完整代码：**[UniLab](https://github.com/unilabsim/UniLab)**
- 本任务 PR：**[unilabsim/UniLab#640](https://github.com/unilabsim/UniLab/pull/640)**

感兴趣的话，按上面的项目就能动手复现这套"CPU 仿真 + GPU 训练"的抓取实践。

---

## English

### Overview

On the open-source framework [UniLab](https://github.com/unilabsim/UniLab) we
trained a PPO policy for a single **OpenArm** to pick up a cube, lift it to an
in-air goal, and hold it. Two things stood out:

1. We wanted it to *clamp* — instead it **invented an "open fingertip-cradle"**:
   it barely closes its fingers, cradling the cube between two fingertips, which is
   actually more robust for this small, high-friction cube.
2. One training curve (`action std`) **drifted out of control up to 39**; a
   **single hyperparameter** pulled it back to 1.35, cleaning the curves while
   slightly *improving* success.

Final deterministic eval: **ever-success 100%, final-success 87.9%, drop rate 0%**.

![Overview replay](assets/gifs/play_overview.gif)

### Environment

- **Hardware**: AMD Instinct **MI300X / MI210** GPUs
- **Platform**: **ROCm** — first-class in UniLab; `make sync-rocm` switches deps in one step
- **Framework**: [UniLab](https://github.com/unilabsim/UniLab), a **CPU-sim +
  GPU-training** heterogeneous robot-RL framework (MuJoCo / Motrix backends,
  config-driven, unified CLI)

```
┌───────────────────┐                            ┌─────────────────────────┐
│  CPU Physics Sim  │   Unified Shared Memory    │   GPU Policy Training    │
│   MuJoCo/Motrix   │ ─────────────────────────▶ │     PPO / SAC / TD3      │
└───────────────────┘    SharedReplayBuffer       │ CUDA / MPS / ROCm / XPU  │
                                                  └─────────────────────────┘
```

### What we did

- **From binary to continuous gripper**: start with a binary (snap-close) gripper,
  then hand **continuous** gripper control to the policy with a staged grasp
  shaping (open above → descend → close → lift).
- **The surprise — open cradle**: evaluation showed finger closure ≈ 0 yet a 100%
  lift rate. RL solves the easier, better problem it discovered, not the one we posed.
- **Cleaning the wild curve**: `action std` blew up because, after tanh saturation,
  inflating noise doesn't hurt reward, so PPO farms the free entropy bonus. Lowering
  `entropy_coef` from `0.01` to `0.003` fixes it (just a new owner-variant YAML, no
  Python changes).

Key commands (full flow in the project repo):

```bash
make sync-rocm          # install the ROCm environment
# train
uv run train --algo ppo --task openarm_demo_pick --sim mujoco --profile lift3d_contgrip_lowent
# deterministic eval
uv run scripts/eval_openarm_success.py task=openarm_demo_pick/mujoco_lift3d_contgrip_lowent \
  algo.load_run=<your_run> +training.eval_envs=512
```

![Left-arm right-front close-up: the open cradle in detail](assets/gifs/play_closeup_leftfront.gif)

### Results & takeaways

| Metric | baseline `0.01` | tuned `0.003` |
| --- | --- | --- |
| ever success (512-env deterministic eval) | 98.8% | **100.0%** |
| final success | 86.3% | **87.9%** |
| drop rate | 0% | 0% |
| final `action std` | 39.08 | **1.35** |

Three takeaways:

1. **Config first**: express ideas as config, not code — controlled experiments are
   cheap and traceable.
2. **Watch every curve**: "success didn't drop" ≠ all-clear — the runaway `action
   std` hid right behind it.
3. **Let evidence speak**: the open-cradle grasp wasn't a bug, it was a better
   solution — understand before you judge.

### References / Reproduce it

- Framework & full code: **[UniLab](https://github.com/unilabsim/UniLab)**
- This task's PR: **[unilabsim/UniLab#640](https://github.com/unilabsim/UniLab/pull/640)**

If this caught your interest, the project above is all you need to reproduce this
"CPU-sim + GPU-training" grasping practice hands-on.
