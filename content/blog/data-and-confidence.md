---
title: "The data behind the engine: sources, cadence and confidence"
slug: "data-and-confidence"
date: 2026-07-30
draft: false
description: "What the decision laboratory reads, how often, how much it trusts each source, and where each one enters the engine."
---



## 1. The Set Up

{{< diagram src="data-confidence-setup" alt="Decision lab quick overview: source registry and unstructured evidence feed capture and reconcile, then engine output, ending in a Gameweek Decision Record." caption="Lab at a glance — registry and evidence into capture → reconcile → engine → Gameweek Decision Record." >}}

This is very much a work in progress. I've been running versions of these on historical replays to try and understand what value to put on each piece of information, and deliberately not using previous examples or what others have worked on because there's plenty of examples of those out there. I'm trying to use agents in the development of this to see how they weight the different bits of information in planning this engine, with guidance from myself and others. 

So while I want to try and keep the engine immutable as we go through the season, I think if there may well be obvious updates to provide or new data sources that can provide value to increase that agent's capability and the engine's capability as we go through the season, then I will do that. 

## 2. Data Sources

{{< diagram src="data-confidence-sources" alt="Sources and cadence: FPL API, Odds API, World Cup priors and Rules YAML into the decision engine; unstructured sources into agent review; failure policy stop, degrade, or use cache and report." caption="Sources, cadence and failure policy — structured feeds into the engine, unstructured into agent review." >}}

The live infrastructure for each game week, which will take in prices, fixtures, availability, ownership, will come from the FPL unofficial API - [https://github.com/mcclowes/fpl-oas](https://github.com/mcclowes/fpl-oas) - Very kindly updated and maintained by community contributors. Obviously being unofficial, it may not always be reliable and is reliant on those endpoints not being changed, but for now, this is what we'll be using and then we'll adapt that plan if not.

From here, you can get quite a lot. We'll be bringing in status news, chances of playing, transfer counts, price changes, official strength ratings for attack, defence, home and away, average scores and deadlines. To note, with the season approaching, this hasn't been formally tested.

I'm using Odds API as the source of betting odds at the moment, but I might start using a couple of different endpoints for this. I've been running with Betfair's historical data in replays. But Odds API gives a good free tier. 

This year I'm also integrating a core on the potential impact on performance of the World Cup and effected players. Not an easy one to determine but I'm working the agents to understand some ways to use and for how long into the season. I don't want to overstate this element and reality alongside the other data points it will play a small part. It will also not affect that many players. 

Each source carries a `max_staleness` and a failure policy, whic is either **stop** (no data beats wrong data), **degrade**, or **use cache and report**.

Before data enters the engine it has to pass the **source registry criteria**. This is a versioned YAML file in the repo. It helps govern the fact that agents could be drawing in stale data, which I've had already with some entries from 2018! I've since tightened the parameters.

Each entry is a governance record, and the fields that we use are:


| Field                            | What it controls                                       |
| -------------------------------- | ------------------------------------------------------ |
| `source_id`                      | Stable name the pipeline and agents use                |
| `authority`                      | Canonical vs secondary (who wins in a conflict)        |
| `licence_status` / `allowed_use` | Whether we may collect, retain, or only cite           |
| `collection_method`              | API, download, permitted fetch, or manual              |
| `expected_cadence`               | How often we expect updates                            |
| `max_staleness`                  | Age budget before a snapshot is too old for a decision |
| `failure_policy`                 | stop / degrade / use cache and report                  |
| `enabled`                        | Hard gate — off means the agent must not pull it       |
| `review_date`                    | When we owe ourselves another look                     |


On what agents may search by the time a decision is being made, the first port of call is the **evidence ledger**, so whatever has already been gathered through the week, structured captures plus unstructured items written in. The decision agent searches that corpus so it is not starting from a blank open browse of the internet, although it can use search to further validate anything it needs to realted to team choice. Research throughout the week is a separate job, done by another agent, or a manual entry (not planning on this happening much).

At decision time that search is scoped to enabled sources, so anything with staleness should get parsed out. If the decision agent still wants to clarify something or pull a bit more, that can go out for further consultation, still under registry and prompt rules. I will still be overseeing all of this as I want to understand what they are doing and pulling from. I want most of the search done and logged already and some team decision early on, but I also want that final agent able to see what is available, verify the decision, and collect more if it has to.

## 3. The confidence model

The confidence in the data and the weight it is given in each decision step is likely to evolve and it has done in historical re-runs. I will probably continue with tweaks throughout the season, it is not a matter of being done from GW1, as long as those changes are logged and accounted for. We've got a huge range of different sources and we are making the decision alongside an agent around how to weight something. I've been involved in weher we should include a source or not, and whether, especially when we're doing historical replays, how and when we weight information. I'm trying to build in some methods to the model that are repeatable but again this will be an ongoin review.

**Authority and staleness.** Every source in the registry carries an authority tier which primarily makes some judgment between canonical vs secondary, then we have a `max_staleness`score, and a failure policy. Canonical will typically mean official FPL / Premier League material, secondary means community or derived intel from open source for example. Staleness is a predetermined age budget to manage the effect of time on the relevance of some piece of information. 

Failure policy is itself a confidence level with a few different tiers. **Stop** means we should continue wihtout data rather than an incorrect submission. **Degrade** means the decision can proceed with a weaker substitute. **Use cache and report** means yesterday’s snapshot is acceptable if we record thatit has been used. Secondary sources do not override canonical ones when they conflict but further research ca be assigned to validate.

**How we score structured forecasts.** On the historical side we evaluate each baseline with metrics matched to the quantity. Start probabilities use **Brier score** (mean squared error of a probability against the 0/1 outcome of whether the player started). On 2022/23–2024/25, a rolling start-probability model sits around Brier **0.099**, against a naive position of started last Gameweek, the baseline would sit at about **0.123**. Expected minutes and points use **MAE (Mean Absolute Error) / RMSE (Root Mean Squared Error)**. Team-strength Elo is scored with **log-loss** on home-win outcomes. 

**How we evaluate a piece of unstructured evidence.** Evidence should not rewrite a forecast directly. The current proposed thresholds (v0.1 - to be monitored - it is hard to replicate this with historical seasons) are:

- claim confidence ≥ **0.55**
- adjustment confidence ≥ **0.60**
- absolute start-probability delta capped at **0.25** (so one article cannot swing 90% → 10%)
- citation required; expiry (`expires_at`) required
- reject if published after the decision deadline; warn if the material is older than **72 hours**
- text that looks like prompt-injection is quarantined and cannot become an adjustment

Again, this may change as i'll be running some modelling at the end of each week after the official team decision has been locked in and verifying decisions and feedin that back in where it will influence decisions in the future.

Confidence on a claim is not yet a learned reputation model, which will be a later phase. Today it is an explicit field on the claim and on the adjustment, assigned when the evidence is extracted, then gated by those thresholds. Conflicts between claims are recorded and reviewed. The adjustment, if accepted, changes an assumption (for example start probability 72% → 61%). The deterministic forecast and optimiser then re-run. 

## 4. Where unstructured data enters: ledger, models, and deterministic search

{{< diagram src="data-confidence-ledger" alt="Evidence ledger and daily agent review: unstructured sources into the ledger, deterministic search by the decision agent, then Model A / B / local models through policy gates to adjust assumptions and re-run the engine." caption="Evidence ledger — deterministic search over what we already hold, then multi-model extract and review." >}}

Structured data can be snapshotted and scored. Unstructured data such as press conferences, club statements, injury notes, blogs, the official FPL `news` field has to be processed by the agents assigned. That is where models come in, and where I am deliberately not locking to a single vendor or a single prompt. The plan is to run more than one model over the same material, partly as a capability check and also as a benchmark. I've a real interest in small local models and I want to compare outputs against the frontier models. 

Everything the agents are allowed to reason over sits in an **evidence ledger** first (as discussed above), a versioned store of where each piece of unstructured material came from and what we did with it. If policy lets an assumption move, every entry still keeps its log

On top of that ledger sits a rapid search capability that is deterministic. This is a model I've used elsewhere for knowledge bases but it's quick and I've had agents use it as a search layer. It is probably unnecessarily fast as we don't need quick decisions, but it enables a lot of research to be done without costing a huge amount in terms of token budget. 

The daily loop is open to change. But it will roughly follow this path. Capture or link new unstructured material into the ledger. Run the deterministic search for the players and fixtures in focus. Hand that slice to one or more models to extract claims and propose signals. A second pass (another model, or a challenger role) reviews the extraction. It looks for conflicts, stale material, over-confident jumps. Anything that clears the confidence and citation gates is then a proposed adjustment to an assumption on the decision plane.

We have four stages really, **Document, Claim, Signal and Adjustment**. For example. a manager press conference lands in the ledger with a claim like - “Player X trained today and will be assessed” which would equal a signal of maybe “availability uncertain; no confirmed start” so we'd hopefully see a  proposed adjustment start probability 72% → 61%. The player would then drop from candidate plan 1 to plan 3 for that model. 

The models I'll be looking at are GPT 5.6 Sol, Luna, Grok 4.5, potentially Opus (Fable would be interesting — but I do have other work and can't blitz usage) and then small models will be Qwen 3.6 27B and Gemma 4 — possibly the small 12B — this is where I'd love to look at a fine-tune, but time.

5.6 is currently doing the daily scan for unstructured data as we speak.

I'll update on the historic replays and their outcomes from the ones we've run so far and how we've managed the forecasting and the small amounts of unstructured data we've tried to inject on certain gameweeks.