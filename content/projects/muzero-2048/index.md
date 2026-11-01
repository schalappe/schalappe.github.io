---
title: "Stochastic MuZero for 2048"
description: "A reinforcement learning agent for 2048 that plans with a learned model and tree search over random tile spawns, written in JAX."
weight: 2
year: 2026
repo: "https://github.com/schalappe/simulate_2048"
stack: ["JAX", "Flax", "Optax", "mctx", "NumPy", "RunPod"]
result: "Reached tile 2048 in 2 of 16 games after 6.8 h on one GPU (about $4); mean score 13,446 against 2,616 untrained"
demo_caption: "Recording of an earlier agent from 2023, before the MuZero rewrite. The 2026 model was not kept after its training run."
---

## Problem

2048 looks simple, but each move mixes a decision and chance: the player slides the tiles, then a 2 or a 4 appears on a random empty cell. An agent that plans ahead has to reason about both. I used the game as a small, fast testbed for planning under uncertainty, and the project grew in stages: DQN and actor-critic agents in 2022, a hand-written Monte Carlo tree search with chance nodes in 2024, and a Stochastic MuZero rewrite in JAX in 2026.

## Approach

The current version follows ["Planning in Stochastic Environments with a Learned Model"](https://openreview.net/forum?id=X6D9bAHhBQ1) (Antonoglou et al., ICLR 2022), including its 2048 settings (Appendix C). The agent never sees the game rules during search. It learns six functions:

- representation: board to hidden state;
- prediction: hidden state to policy and value;
- afterstate dynamics: hidden state and action to the state after the slide, before the new tile;
- afterstate prediction: afterstate to value and a distribution over 32 chance codes;
- dynamics: afterstate and chance code to next state and reward;
- encoder: two consecutive observations to the discrete chance code of the real transition, learned without labels.

Each tile is encoded as 31 bits, values and rewards are predicted as categorical distributions over 601 bins, and value targets are TD(λ) returns over real rewards. Search uses DeepMind's `mctx.stochastic_muzero_policy` with illegal moves masked. Training unrolls the model 5 steps on sequences from a prioritised replay buffer.

## What I built

- A 2048 engine in NumPy and a vectorised version in JAX that splits each move into a deterministic slide and the random tile spawn.
- The six networks in Flax, as residual MLPs, and the bridge between them and `mctx`.
- Self-play compiled into a single JAX program on the GPU: hundreds of games, search and move selection run in one `lax.scan`.
- A prioritised replay buffer that stores boards as 16 bytes each instead of full observations (the paper's buffer would otherwise take about 50 GB).
- Resumable runs: a run directory holds checkpoints, optimizer state, the replay buffer and metrics, so a restarted GPU pod continues where it stopped.
- Presets from `tiny` (CPU smoke run) to the paper's settings, a `budget` preset that stops at a target tile or a time limit, and a RunPod script that keeps the time budget across restarts and stops the pod when training ends.
- 86 unit tests, run on CPU and on an NVIDIA A40.

A first version of the training loop ran but could not learn what it claimed: the chance code was a constant, value targets were computed from the search's own values, and games stopped at 200 moves. I rewrote the losses and targets to match the paper before spending any GPU time.

## Results

The `budget` preset trains a smaller model than the paper (128 units, 4 residual blocks, 50 simulations per move, search depth capped at 10). On one A40, it stopped on the target tile at step 75,000, after 6.8 hours, for about $4 of GPU. Each evaluation plays 16 games without exploration.

| Evaluation | Mean score | Best tile | Games reaching 2048 | Mean length |
|---|---|---|---|---|
| Untrained network + search | 2,616 | 512 | 0/16 | 221 |
| Step 20,000 | 5,712 | 512 | 0/16 | 416 |
| Step 40,000 | 7,714 | 1024 | 0/16 | 520 |
| Step 65,000 | 10,624 | 1024 | 0/16 | 675 |
| Step 75,000 | 13,446 | 2048 | 2/16 | 804 |

The untrained baseline matters: search alone already plays better than chance, so the gain comes from comparing it with the trained model under the same search. Profiling showed that self-play takes about 95% of the loop, and slows down 2.5 to 3 times as training sharpens the chance distribution and deepens the search tree.

## Limitations and next steps

This run proves the model learns to reach 2048, not that it matches the paper. The paper trains for 20 million steps on TPUs; at the measured 0.44 steps per second of the full-size model on an A40, that would take about 526 days and $7,450. Two games out of sixteen is a small sample, and the trained model was deleted with the pod, so it cannot be evaluated further. The next run should keep its checkpoints and evaluate on more games.
