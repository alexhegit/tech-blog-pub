# LinkedIn post (ready to paste)

> 建议配图：`assets/images/openarm_pick_grasp_closeup.png`（抓取特写）或对比曲线。
> Suggested image: the grasp close-up, or the before/after training curves.

---

We taught a robot arm to pick up a cube. It invented a grip we never taught it. 🤖

Using reinforcement learning on the open-source UniLab framework, we trained a
single robot arm to pick up a small cube and hold it at an in-air target.

Two things surprised us:

1) It almost never *clamps* the cube. Instead it learned to *cradle* it on its
fingertips — like balancing a candy on chopstick tips. For a tiny, slippery cube,
that turned out to be far more robust than squeezing. The policy didn't solve the
problem we posed; it solved a smarter one it discovered.

2) One training curve went wild — climbing endlessly even after success had
plateaued. The algorithm had found a loophole to farm "exploration bonus" for
free. A single hyperparameter change pulled it back in line — and success went
*up*, not down.

The lesson I keep relearning: in RL, pretty numbers aren't the whole story, and
the model is often more creative than you. Watch every curve, and ask whether a
surprising behavior is a bug — or a better solution.

Full write-up + reproducible code (one command to train, eval, and record):
👉 UniLab: https://github.com/unilabsim/UniLab
👉 PR #640: https://github.com/unilabsim/UniLab/pull/640

#ReinforcementLearning #Robotics #PhysicalAI #MachineLearning #OpenSource #RobotLearning

---

## 中文版（可选，用于中文 LinkedIn 受众）

我们教一条机械臂捡方块，它却自己发明了一种我们没教的抓法。🤖

基于开源框架 UniLab，用强化学习训练单臂把小方块捡起并举到空中目标点。两个惊喜：

1）它几乎从不"夹"，而是用指尖把方块"托"起来——对又小又滑的方块，这比夹紧鲁棒得多。
它没解我们出的题，而是解了它自己发现的更聪明的题。

2）一条训练曲线"失控"狂涨：成功率早封顶了，算法却钻空子白薅"探索奖励"。只调一个超参，
曲线立刻平稳，成功率还略升。

复盘心得：RL 里漂亮的数字不是全部，模型常比你更有创意。盯住每条曲线，并先问一句——
这个意外行为，是 bug，还是更优解？

代码与复现 👉 https://github.com/unilabsim/UniLab ｜ PR #640
