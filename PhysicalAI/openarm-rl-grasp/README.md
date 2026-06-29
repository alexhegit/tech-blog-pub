# 我们教机械臂捡方块，它却发明了一种我们没教的抓法

> We Taught a Robot Arm to Pick Up a Cube — It Invented a Grip We Never Taught It

**语言 / Language:** [中文](#中文) · [English](#english) ｜ ⏱ 约 4 分钟 / ~4 min read

![机械臂用指尖托住方块](assets/images/openarm_pick_grasp_closeup.png)

---

## 中文

### 一个简单的任务

我们让一条机械臂做一件小孩都会的事：把桌上的小方块捡起来，举到半空中一个指定的位置，
然后稳稳拿住。

听起来简单，但对机器人来说并不轻松。我们没有手把手地写"先张开、再下去、然后夹住、最后
抬起"这样的程序，而是用**强化学习**——给它一个目标和一套奖惩规则，让它在仿真里自己试错
几亿次，慢慢摸索出该怎么动。

### 它给了我们一个惊喜

训练完，我们检查它到底学会了什么，发现一件反直觉的事：

**它几乎从不"夹"方块。**

我们本以为它会像人一样把两根手指捏紧。可数据显示，它的手指基本一直是张开的——它学会
的是用两根指尖把方块**兜住、托起来**，像用筷子尖端稳稳挑起一颗糖，而不是用力夹。

一开始我们以为是出了 bug。但仔细一想：对这个又小又滑的方块，"夹紧"反而更容易失手——
稍微没对准就把它弹飞了；而"托住"靠的是形状和摩擦，容错高得多。

换句话说，**它没有解我们出的题，而是解了一道它自己发现的、更聪明的题。** 这正是强化学习
最迷人的地方——有时候它比你更懂怎么把事情做好。

### 还有一条"失控"的曲线

训练过程里我们还碰到一个有意思的现象。机器人其实很早就把任务学会了，成功率早早封顶，
但监控面板上有一条曲线却一路疯涨、停不下来。

排查后发现：这条曲线代表机器人动作里的"随机抖动量"。由于一个技术上的小机制，算法发现
**多抖一点既不会把事情搞砸、还能多拿一点"探索奖励"**——于是它就一直钻这个空子，把抖动
越加越大。这不影响它实际的表现，但让曲线很难看，也容易让人误判。

我们只调了**一个参数**（把"探索奖励"的权重从 0.01 降到 0.003），曲线立刻平稳了下来，
而且成功率不降反升。

![调参前后的训练曲线对比](assets/images/openarm_pick_lowent_curves.png)

### 三个小收获

1. **AI 常常比你更有创意**：它学出的"托举"抓法，是我们没设计、却更鲁棒的方案。先别急着
   "纠正"它，先想想它是不是发现了更优解。
2. **数字漂亮 ≠ 万事大吉**：成功率封顶了，但另一条曲线在失控。要盯住每一个指标。
3. **小改动，大不同**：有时候一个超参数，就能让结果从"能用"变成"干净又稳"。

### 想亲自上手？

这套实践完全开源，基于 [UniLab](https://github.com/unilabsim/UniLab) 机器人强化学习框架。
你可以一行命令复现训练、评估和录像：

➡️ **代码与复现**：[UniLab 仓库](https://github.com/unilabsim/UniLab) ·
[本任务的 PR #640](https://github.com/unilabsim/UniLab/pull/640)

🎬 [夹爪动作特写视频](assets/videos/play_closeup_leftfront.mp4)

---

## English

### A Simple Task

We asked a robot arm to do something a toddler can do: pick a small cube off the
table, lift it to a spot in mid-air, and hold it there.

Simple — but not easy for a robot. Instead of hand-coding "open, go down, close,
lift," we used **reinforcement learning**: give it a goal and a set of rewards,
then let it try hundreds of millions of times in simulation and figure out the
motion on its own.

### It Surprised Us

When we inspected what it had actually learned, we found something
counter-intuitive:

**It almost never "clamps" the cube.**

We expected it to pinch its two fingers shut like a human would. But the data
showed the fingers staying mostly open — it learned to **cradle** the cube on its
fingertips and lift it, like balancing a candy on the tips of chopsticks rather
than squeezing it.

We first assumed a bug. Then it made sense: for this tiny, slippery cube,
clamping is actually *more* likely to fail — a small misalignment flicks the cube
away. Cradling leans on shape and friction, and is far more forgiving.

In other words, **it didn't solve the problem we posed — it solved a smarter
problem it discovered.** That's the magic of reinforcement learning: sometimes it
knows better than you how to get the job done.

### And One Curve Went Wild

During training we hit another interesting moment. The robot actually learned the
task early — success plateaued quickly — yet one line on the dashboard kept
climbing without end.

It turned out to track the amount of "random jitter" in the robot's actions.
Because of a small technical quirk, the algorithm discovered that **adding more
jitter neither hurt performance nor stopped a little "exploration bonus"** — so it
kept gaming that loophole, inflating the jitter more and more. It didn't affect
real performance, but it made the curve look broken and easy to misread.

We changed **one parameter** (lowering the exploration-bonus weight from 0.01 to
0.003), and the curve immediately settled — while success actually went *up*.

![Training curves before vs after the fix](assets/images/openarm_pick_lowent_curves.png)

### Three Takeaways

1. **AI is often more creative than you**: the cradle grasp was something we never
   designed, yet more robust. Before "correcting" it, ask if it found a better
   solution.
2. **Pretty numbers ≠ all clear**: success had plateaued, but another curve was
   out of control. Watch every metric.
3. **Small change, big difference**: sometimes a single hyperparameter takes a
   result from "works" to "clean and stable."

### Want to Try It Yourself?

The whole thing is open source, built on the
[UniLab](https://github.com/unilabsim/UniLab) robot RL framework. You can
reproduce training, evaluation, and video recording with a single command:

➡️ **Code & repro**: [UniLab repo](https://github.com/unilabsim/UniLab) ·
[PR #640 for this task](https://github.com/unilabsim/UniLab/pull/640)

🎬 [Close-up of the gripper in action](assets/videos/play_closeup_leftfront.mp4)
