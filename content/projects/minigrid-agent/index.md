---
title: "Maze-solving agents on MiniGrid"
description: "PPO with curiosity-driven exploration and Rainbow DQN, trained from pixels to navigate multi-room mazes of increasing difficulty."
weight: 2
year: 2025
repo: "https://github.com/schalappe/reinforce_minigrid"
stack: ["TensorFlow", "Keras", "TensorFlow Probability", "MiniGrid", "Gymnasium", "Pydantic"]
demo_caption: "Recording from the first version of the project (2023), on the MiniGrid KeyCorridor environment."
---

## Problem

An agent drops into a grid of rooms connected by doors and has to reach a green ball. It only sees a small window in front of it, as an image, and the reward comes at the very end. With sparse rewards and partial views, a standard agent can wander for a long time without learning anything. I wanted to see which mix of algorithm, exploration and reward shaping gets it to the goal. A first actor-critic version dates from 2023; I rebuilt the project in 2025.

## Approach

I built four custom MiniGrid environments that form a curriculum:

- `BaseMaze`: 2×2 rooms, doors open;
- `EasyMaze`: 2×2 rooms, doors closed;
- `MediumMaze`: 3×3 rooms, doors closed;
- `HardMaze`: 3×3 rooms with 4 distractor objects.

Training moves to the next level when the mean reward passes a threshold or after a fixed step budget. Observations are 56×56 RGB images of the agent's partial view. The shaped reward gives +10 for the goal, a small bonus for getting closer and for visiting new rooms and cells, and penalties for hitting walls and for each step.

## What I built

I wrote two agents that share a `BaseAgent` interface and a factory:

- PPO with an IMPALA-style residual CNN, GAE over 8 parallel environments, Random Network Distillation (RND) as a curiosity bonus, and hybrid exploration: decaying ε-greedy, UCB counts on actions and an entropy coefficient that adapts to a target.
- Rainbow DQN with its six parts: dueling heads, double Q-learning, prioritised replay, 3-step returns, noisy layers and a 51-atom categorical value distribution.

I also added a YAML configuration validated with Pydantic and overridable from the CLI, a Kaggle notebook for GPU training, a script that renders a trained agent to a GIF, and keyboard control to play the mazes by hand.

## Results

The repo does not record training runs: no learning curves, logged success rates or saved models. The visualisation script can still load a checkpoint and render an evaluation episode as a GIF. I can't claim a success rate on the hard maze from the repo as it stands.

## Limitations and next steps

The Rainbow DQN trains only on `BaseMaze`; the curriculum is wired into PPO alone. Tests cover the prioritised replay buffer and nothing else. The reward shaping is hand-tuned, so a good score partly reflects my bonuses rather than pure task success.

Next, I would log success rate and episode length per level, publish the curves for both agents, run DQN through the same curriculum, and compare shaped and sparse rewards to measure how much the shaping helps.
