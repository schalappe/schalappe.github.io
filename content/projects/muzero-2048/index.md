---
title: "Stochastic MuZero for 2048"
description: "A reinforcement learning agent for 2048 that plans with a learned model and tree search over random tile spawns, written in JAX."
weight: 2
year: 2026
repo: "https://github.com/schalappe/simulate_2048"
stack: ["JAX", "Flax", "Optax", "mctx", "NumPy"]
in_progress: true
result: "Full self-play-to-checkpoint pipeline and about 70 unit tests; no trained agent yet"
demo_caption: "Recording of an earlier agent from 2023, before the MuZero rewrite. The current agent has no trained results yet."
---

## Problem

2048 looks simple, but each move mixes a decision and chance: the player slides the tiles, then a 2 or a 4 appears on a random empty cell. An agent that plans ahead has to reason about both. I used the game as a small, fast testbed for planning under uncertainty, and the project grew in stages: DQN and actor-critic agents in 2022, a hand-written Monte Carlo tree search with chance nodes in 2024, and a Stochastic MuZero rewrite in JAX in 2026.

## Approach

The current version follows ["Planning in Stochastic Environments with a Learned Model"](https://openreview.net/forum?id=X6D9bAHhBQ1) (Antonoglou et al., ICLR 2022). The agent never sees the game rules during search. It learns six functions:

- representation: board to hidden state;
- prediction: hidden state to policy and value;
- afterstate dynamics: hidden state and action to the state after the slide, before the new tile;
- afterstate prediction: afterstate to Q-value and a distribution over 32 chance codes;
- dynamics: afterstate and chance code to next state and reward;
- encoder: observation to a discrete chance code.

Search runs 100 simulations per move with DeepMind's `mctx.stochastic_muzero_policy`. Training unrolls the model 5 steps on trajectories from a prioritised replay buffer, with n-step value targets.

## What I built

- A 2048 engine in NumPy and a vectorised version in JAX that splits each move into a deterministic slide (`latent_state`) and the random tile spawn (`after_state`).
- The six networks in Flax, as residual MLPs.
- The bridge between these networks and `mctx`.
- Self-play with parallel games, a prioritised replay buffer with background prefetching, JIT-compiled losses and training step, and Orbax checkpoints.
- Configurations from `tiny` to the paper's settings, a Kaggle notebook for GPU or TPU training, and an evaluation script reporting reward and maximum tile.
- About 70 unit tests on the board logic, the environment and the JAX game.

## Results

The repo does not publish a trained agent or measured scores yet. The evaluation script reports mean reward, mean maximum tile and the tile distribution, but no run is recorded in the repo. Today, the tests cover the game engine, and the repo holds the complete training pipeline, from self-play to checkpoints.

## Limitations and next steps

The chance-code target in the loss is still a placeholder: it always points to code 0 instead of encoding the next observation with the encoder. Until I fix that, the model does not learn the stochastic part of the game. The `--checkpoint` option of the evaluation script is not implemented, so it evaluates an untrained network.

Next, I will wire the encoder into the loss and implement checkpoint loading in the evaluation. Then I will run a long training on Kaggle and publish the learning curves and tile distribution.
