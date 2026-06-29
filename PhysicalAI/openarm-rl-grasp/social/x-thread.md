# X / Twitter thread (ready to paste)

> 配图建议：1/ 配抓取特写或视频；4/ 配对比曲线图。
> Media: attach the grasp close-up/video on tweet 1; the curves on tweet 4.

---

1/
We taught a robot arm to pick up a cube with reinforcement learning.

It invented a grip we never taught it. 🧵🤖

2/
The task: pick a 3cm cube, lift it to an in-air target, hold it.

We didn't script "open → down → close → lift." We gave it rewards and let it try
~147M times in sim on the open-source UniLab framework.

3/
The surprise: it almost never *clamps* the cube.

It learned to *cradle* it on its fingertips instead — like balancing candy on
chopstick tips. For a tiny, slippery cube, cradling is way more forgiving than
squeezing.

It solved a smarter problem than the one we posed.

4/
Then a training curve went wild 📈

Success had plateaued early, but one line kept climbing. The algorithm found a
loophole: inflate action noise → farm "exploration bonus" for free, no penalty.

One hyperparameter (entropy_coef 0.01 → 0.003) fixed it. Success went UP.

5/
Takeaways:
• AI is often more creative than you
• Pretty numbers ≠ all clear — watch every curve
• A surprising behavior might be a better solution, not a bug

6/
It's all open source. One command to train, eval, and record video.

Code 👉 https://github.com/unilabsim/UniLab
This task (PR #640) 👉 https://github.com/unilabsim/UniLab/pull/640

#RL #Robotics #PhysicalAI #RobotLearning
