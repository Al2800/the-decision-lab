---
title: "Catan side track"
slug: "catan-qlora-side-track"
date: 2026-08-03
draft: false
description: "Side track on training a thin QLoRA Catan model in the same decision lab."
---

I've been writing Decision Lab intially around Fantasy Premier League and agentic decision making. Trying to figure out, of course with agents, on how do you get a model to make decent choices under uncertainty, with structure, and with a way to check whether it's actually improving?

So I've been running a side track on Settlers of Catan.

The sandbox is Catanatron, an open Catan engine with real bots you can
play against. We generated a big pile of expert style games from those
bots, then turned the decisions into training rows.  The model is learning
to imitate strong play at each decision point.

I was inspired by Replit's chess engine, so i decided to also take a small LLM throught some fine tuning. We've gone with Qwen 3.5 9B model and training with thin QLoRA adapters on top. We're not rewriting the whole model, just teaching a small set of extra weights to steer it toward Catan decisions, which keeps rental GPU cost realtively small. I say we but this is all largely agent run, with Sol managing the Hugging Face runs.

Training is supervised fine tuning on those expert decisions. It gets shown the board prompt, the expert's JSON action and then all being well pushed to making consistently good decisions. Its been done in chunks so far, saving every 200 steps so a long rental job doesn't actually get wiped or hit error. We're at checkpoint 1400 on the way to 2000.

Early on, the model was spending its token budget on thinking and never actually emitting a legal action. Once that was fixed, an 8 game smoke at 1400 looked healthier. Parse and legality were clean. It won 1 of 8 games on our ladder mix (random / weighted random / value function style seats).

Next is finish out to 2000, then Gate B: a proper 200 game ladder check where the bar is beating WeightedRandom with strong format and legality floors.

This is far more structured than the FPL world which deals with way more variability and unknowns but its still looking at structured state, logged decisions and benchmarks. A lot of the infrstructure is already there and the rules outside of the human negotiating elements are more constrained. I'm hoping there some crossover from the process that can feed into the FPL work.