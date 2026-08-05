---
title: "Historic replays"
slug: "historic-replays"
date: 2026-08-05
draft: false
description: "How historical datasets shaped the engine, what structured Gameweek replays can honestly answer, and where evidence injection fits."
---

Historical datasets are how the engine has developed its initial shape and how I check that a decision can be reconstructed and scored, thanks to the open source dataset maintainers!

I've primarily been using the community Gameweek archive people call vaastav, and the Premier League results and odds CSVs from football-data.co.uk. Both sit in the source registry, downloaded locally, kept out of Git and neither is obviously a live feed. They are the training and replay fodundation for the structured side of the system( I am continually adding more where i can).

## What do they contain

Vaastav gives player Gameweek rows across roughly a decade: minutes, points, prices, ownership, and in later seasons an xP field and some defensive columns. It is good for asking, given structured stats that should have been roughly knowable at a previous GW deadline. It is not a full picture of what a manager has prior to a game but it gives a foundation to work from. There is no reliable pre-deadline news environment in those files.

football-data.co.uk fills a another gap. Match results and bookmaker odds give market-implied match and clean sheet baselines, and enough history to fit a simple team strength Elo. Player level props are thin historically, so anytime goalscorer style signals are mostly out of reach. Clean sheet and 1X2 probabilities are the usable core.

Together they are enough to design and evaluate the structured path of the engine. A large part the replays are currently missing is the weekly noisy unstructured data stream, so they are not enough, on their own, to claim that an evidence reading agent would have made the same call in 2024 that it would make live in 2026.

## Designing around that limit

Multi-season replay is the primary way to compare structured data strategies. Evidence dependent agent strategies are very difficult to pull back enough unstructured data validate the dates it was known and then feed it into the engine. Where I have ingested unstructured data for historical replays its been as a test of the pipeline and how it might effect a specific team decision. So the lab does two different things with past data.

First, look at how to validate the datasets before trusting them. Coverage, licence, identity match rates across seasons. Closing odds in a historical CSV are not the same as odds captured at the FPL deadline and we don't know the cut off or when the last thing to influence them was, but for the purposes of testing ingestion and impact on team selection, I've carefully introduced them.

Second, build baselines that can be rerun and new data introduced or decisions changed to monitor outcomes and then feed that back into the engine and test what's having an impact or not. It also lets you check for edge cases and faults - for a basic example changing expected minutes to 0 and then are they considered for a start. Even looking at team strengths and projected minutes versus what we actually do know took place after the fact as well as team ratings and any trends of historic projections versus reality. We will look at this throughout the season to refine the engine and agentic elements on decision making.

## What a historic replay looks like

A structured replay here is a Gameweek Decision Record produced under a frozen information set. Early on the pilot set was selected Gameweeks in 2023/24 and 2024/25. Since then we have also run a fuller enhanced 2025/26 season replay across all 38 Gameweeks. I ran a few different arms against it, each dealing with the data in a slightly different way. I will go into the numbers properly in a later note. 

## Injecting evidence into selected Gameweeks

Evidence injection is a different experiment again. Because historical news is not recoverable on bulk, I chose specific game weeks to look back and find news stories and blogs, to see how the pipeline works and what the decision making around it might be, even with a small sample. It was a controlled run by a separate agent to document the data pre a certain daate, have the agent review it, and pull out any relevant signal.

I was checking how it was cited, the confidence scored, what time limits it was given, etc, then once the adjustment is applied, for example a start probability moved from 72% to 61% for a named player, does the ranked plan set change in a way we can measure, and what happens to realised points if we then attach the actual Gameweek outcome. Hard to replicate at the scale I want to do it for the 26/27 season! But the replays can verify parts of the foundational engine and the wiring for the noisier data.

I will print the outcomes from the 25/26 38 GW run and will try to go deeper on the initial forecast baselines and how it was influenced at each stage. There will be a lot of work tweaking this throughout the season. I'm now applying a lot of this to the starting line up and the first 6 weeks, testing elements of forecasting with daily evidence capture ongoing.
