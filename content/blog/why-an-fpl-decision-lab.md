---
title: "Why an FPL decision laboratory"
slug: "why-an-fpl-decision-lab"
date: 2026-07-29
description: "Fantasy Premier League as a controlled environment for studying how AI agents make decisions under uncertainty."
---

This site will document the building of an **agentic decision laboratory**: an open, reproducible environment that compares deterministic analytics, mathematical optimisation, single-agent reasoning and multi-agent orchestration, using point-in-time evidence and auditable outcomes.

The test environment is Fantasy Premier League. That choice is deliberate as a test sandbox for pulling together analysis of structured and unstructured data, using an algorithmic engine, and then overlaying AI and agentic models to interpret, in particular, the unstructured data, and align it with the structured data outputs. This stems from my own work, reframed into an entertaining format with some competition and clear outcomes!

I'm really interested in how to use AI alongside deterministic profiles of data, without it going wild.

I wouldn't want to overstate it, but there are other applications in my own wor and obviously clear crossover into any other industry where you get these two conflicting data types and emerging methods of working with them.

FPL combines properties that make decision-making genuinely hard to study well:

- structured and unstructured data;
- explicit rules and hard constraints;
- uncertain player availability and performance;
- changing prices and fixtures;
- short-term and long-term planning in tension;
- fixed weekly decision deadlines;
- measurable outcomes, every gameweek.

The overriding goal is not necessarily whether we can predict a football match, but more:

> Does agentic orchestration add measurable value over a conventional data pipeline, forecasting model and optimiser?

Everything else follows from that. Rules live as versioned data. Every record is point-in-time, so any decision can be replayed exactly as it was seen at the deadline. The deterministic core is validation, scoring and optimisation, the language models only propose choices on seeing all the data. The first season runs largely in advisory mode with the system recommending but currently still needs a human to approve and act on the information. I am looking at model computer-use to run the whole pipeline, lest I'm influenced to override the system decision!

{{< diagram src="decision-lab-pipeline" alt="The Decision Lab pipeline: governed sources feed a point-in-time store, then a deterministic engine, an agent review layer, human approval, and the gameweek decision — with outcomes feeding back into the store." caption="The laboratory in one line: deterministic core enforces, agents propose, a human approves. Drawn in tldraw." >}}

Among other things this will be the initial record of the build, and the historical replays that I've done to build out the initial engine. I'll include in later entries what that has included, what the data sources are, how often we're drawing on them, and how it's being brought together, the confidence levels we're assigning to each piece, and what we're asking of different agents.

The agents come in after governance, structured data management, forecasting and optimisation. It will currently be structured so that one agent will be reviewing, ahead of each gameweek, the range of unstructured data available that would affect a decision on whether a particular player is picked or not. Once that data's collected, another will review it and I might look at different models, almost as a benchmark for how they perform, where they draw any clarifying data from, how they build on it, the confidence they assign to each piece, and how they use that alongside the more structured data that each one will get. Each entry will record what was decided, what was rejected, and why.

The repository is public, and I'll keep posting here. There will likely be other bits alongside this, but all relevant back to AI models, data, etc.
