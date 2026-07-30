---
title: "The data behind the engine: sources, cadence and confidence"
slug: "data-and-confidence"
date: 2026-07-30
draft: true
description: "What the decision laboratory reads, how often, how much it trusts each source, and where each one enters the engine."
---



## 1. The Set Up

{{< diagram src="data-confidence-setup" alt="Decision lab quick overview: source registry and unstructured evidence feed capture and reconcile, then engine output, ending in a Gameweek Decision Record." caption="Lab at a glance — registry and evidence into capture → reconcile → engine → Gameweek Decision Record." >}}

This is an overview of what the data engine currently looks like, what it takes as inputs, a map of those inputs, how we manage the data and how it is dated, how much is trusted. 

This is very much a work in progress. I've been running versions of these on historical replays to try and understand what value to put on each piece of information, and deliberately not using previous examples or what others have worked on because there's plenty of examples of those out there. I'm trying to use agents in the development of this to see how they weight the different bits of information in planning this engine, with guidance from myself and others. 

So while I want to try and keep the engine immutable as we go through the season, I think if there may well be obvious updates to provide or new data sources that can provide value to increase that agent's capability and the engine's capability as we go through the season, then I will do that. 

## 2. What we draw on and how often

{{< diagram src="data-confidence-sources" alt="Sources and cadence: FPL API, Odds API, World Cup priors and Rules YAML into the decision engine; unstructured sources into agent review; failure policy stop, degrade, or use cache and report." caption="Sources, cadence and failure policy — structured feeds into the engine, unstructured into agent review." >}}

The live infrastructure for each game week, which will take in prices, fixtures, availability, ownership, will come from the FPL unofficial API - [https://github.com/mcclowes/fpl-oas](https://github.com/mcclowes/fpl-oas) - Very kindly updated and maintained by community contributors. Obviously being unofficial, it may not always be reliable and is reliant on those endpoints not being changed, but for now, this is what we'll be using and then we'll adapt that plan if not.

From here, you can get quite a lot. We'll be bringing in status news, chances of playing, transfer counts, price changes, official strength ratings for attack, defence, home and away, average scores and deadlines. It also covers all that you would expect on fixture lists. With the season approaching this hasn't been formally tested.

I'll be using betting odds, and I'm using Odds API at the moment, but I might start using a couple of different endpoints for this. I've been running with Betfair's historical data in replays. But Odds API gives a good free tier. 

This year I'm also integrating World Cup players and the potential impact on performance. Not an easy one to determine but I'm working the agents to understand some ways to use and for how long into the season. I don't want to overstate this element and reality alongside the other data points it will play a small part. It will also not affect that many players. 

Each source carries a `max_staleness` and a failure policy: **stop** (no data beats wrong data), **degrade**, or **use cache and report**.

Before any of that gets into the engine, it has to clear the **source registry**. That is a versioned YAML file in the repo (`control/sources/source-registry.yaml`). No collector runs, and no agent is told to “just go look it up on the web,” unless the source already has a complete registry entry and an `enabled: true` (or an explicit manual path).

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


**What agents may search.** By the time a decision is being made, the **evidence ledger** is the first port of call — whatever has already been gathered through the week (structured captures, plus unstructured items written in with a `source_id`). The decision agent searches that corpus deterministically. It is not starting from a blank open browse of the internet.

Gathering earlier in the week is a separate job: another agent (or a manual citation) can pull from allowed sources into the ledger under registry rules, so most of what matters is already logged before the final call. At decision time the method is:

1. **Scope from the registry** — only `enabled` sources (and manual citations that already carry a `source_id`) are in the search universe for that Gameweek.
2. **Point-in-time filter** — every hit must satisfy `available_at ≤ deadline`. Same query after the whistle must not suddenly surface a later article.
3. **Deterministic retrieval** — full-text / structured query over the ledger (passages, claims, document metadata). Same query, same corpus, same deadline → same hits.
4. **Web only if needed** — if the decision agent wants to clarify something or pull a bit more, that can go out for further consultation — still under registry and prompt rules, not a silent free-for-all mid-reasoning. Ideally most of the search is already done and logged; I still want that final agent able to see what is available, verify the decision, and collect more if it has to.

In practice: ask the search layer “what do we already hold on player X / fixture Y before this deadline?” → get that slice → one or more models read it and propose claims/adjustments → challenger or policy gates decide what reaches the decision plane — and only then, if needed, go wider.

## 3. The confidence model

```text
  
```

The confidence in the data and the weight it is given in each decision step is likely to evolve and it has done in historical re-runs. We've got multiple different sources and making the decision alongside an agent typically around how to weight something, and whether we should include a source or not, and whether, especially when we're doing historical replays, how and when we weight information, when cutoffs and deadlines are, how many other sources can we use to verify the information provided, everything you typically do to verify evidence. I mention the historical replays there as they've contributed to forming the core decision engine. 

**Authority and staleness.** Every source in the registry carries an authority tier which primarily makes some judgment between canonical vs secondary, then we have a `max_staleness`, and a failure policy. Canonical will typically mean official FPL / Premier League material; secondary means community or derived corpora we have reviewed for private use, for example, where we use historical gameweek data from previous years for certain players to make a judgment call on potentially how they might perform, or certainly as a data point to consider. Staleness is a hard age budget of six hours for the live FPL API snapshots, for example. Failure policy is itself a confidence level with a few different tiers: **stop** means we would rather have a hole than a wrong number; **degrade** means the decision can proceed with a weaker substitute; **use cache and report** means yesterday’s snapshot is acceptable if we flag that we used it. Secondary sources do not override canonical ones when they conflict; they sit beside them or stay dark until review finishes.

**How we score structured forecasts.** On the historical side we evaluate each baseline with metrics matched to the quantity. Start probabilities use **Brier score** (mean squared error of a probability against the 0/1 outcome of whether the player started). On 2022/23–2024/25, a rolling start-probability model sits around Brier **0.099**, against a naive position of started last Gameweek, the baseline would sit at about **0.123**. Soft minutes history earns its keep before any news source is added. Expected minutes and points use **MAE (Mean Absolute Error) / RMSE (Root Mean Squared Error)**. Team-strength Elo is scored with **log-loss** on home-win outcomes. The rule for features is time-based: lagged minutes and points only; same-Gameweek outcomes never sneak in as inputs.

**How we evaluate a piece of unstructured evidence.** Evidence does not rewrite a forecast directly. The current proposed thresholds (v0.1 - to be monitored - it is hard to replicate this with historical seasons) are:

- claim confidence ≥ **0.55**
- adjustment confidence ≥ **0.60**
- absolute start-probability delta capped at **0.25** (so one article cannot swing 90% → 10%)
- citation required; expiry (`expires_at`) required
- reject if published after the decision deadline; warn if the material is older than **72 hours**
- text that looks like prompt-injection is quarantined and cannot become an adjustment

Confidence on a claim is not (yet) a learned reputation model, which will be a later phase. Today it is an explicit field on the claim and on the adjustment, assigned when the evidence is extracted, then gated by those thresholds. Conflicts between claims are recorded rather than averaged without anyone knowing. The adjustment, if accepted, changes an *assumption* (for example start probability 72% → 61%); the deterministic forecast and optimiser then re-run. Agents propose; orchestration accepts or rejects; nothing overwrites the original model output in place.

## 4. Where unstructured data enters: ledger, models, and deterministic search

{{< diagram src="data-confidence-ledger" alt="Evidence ledger and daily agent review: unstructured sources into the ledger, deterministic search by the decision agent, then Model A / B / local models through policy gates to adjust assumptions and re-run the engine." caption="Evidence ledger — deterministic search over what we already hold, then multi-model extract and review." >}}

Structured data can be snapshotted and scored. Unstructured data such as press conferences, club statements, injury notes, blogs, the official FPL `news` field has to be *read -  so enter the agents*. That is where models come in, and where I am deliberately not locking to a single vendor or a single prompt. The plan is to run more than one model over the same material, partly as a capability check and partly as a benchmark. I've a real interest in small local models, particularly those that could be fine-tuned on consumer hardware. I want to see: do they extract the same claim, cite the same passage, assign similar confidence, and propose the same kind of adjustment? 

But models do not get to invent a private memory of the internet. Everything they are allowed to reason over sits in an **evidence ledger** first (as discussed above), a versioned store of where each piece of unstructured material came from and what we did with it. At the bottom: `source_documents` (the article, transcript, post, or official note, with URL, source_id, published/observed times, content hash). Above that: `document_passages` (the chunks we actually index). Then `extracted_claims`, any `claim_conflicts`, `decision_signals`, and finally `proposed_adjustments` if policy lets an assumption move. Every derived row keeps its lineage: which document, which transformation or prompt version, which model run.

On top of that ledger sits a **rapid search capability that is deterministic**. This is a model I've used elsewhere for knowledge bases but it's quick and I've had agents use it as a search layer. For Phase 1 that means rights-aware full-text / structured query over passages and claims. It's fast enough that an agent can call it many times in a daily review without burning the budget, and stable enough that a Gameweek Decision Record can say exactly which search results were in scope. 

The daily loop I want is roughly this. Capture or link new unstructured material into the ledger (manual citation where bulk scrape is not yet licensed; automated where the registry allows). Run the deterministic search for the players and fixtures in focus i.e “what do we already hold on X before this deadline?” Hand that slice to one or more models to extract claims and propose signals. A second pass (another model, or a challenger role) reviews the extraction: conflicts, stale material, over-confident jumps. Anything that clears the confidence and citation gates becomes a proposed adjustment to an assumption on the decision plane. At the end of the day the ledger has grown, the search index has the same facts the agents saw, and tomorrow’s review starts from a known state rather than a chat history that evaporated overnight.

The lifecycle underneath that loop is still the four stages: **Document → Claim → Signal → Adjustment**. Worked example: a manager press conference lands in the ledger with a claim like - “Player X trained today and will be assessed” which would equal a signal of maybe “availability uncertain; no confirmed start” so we'd hopefully see a  proposed adjustment start probability 72% → 61%. The player would then drop from candidate plan 1 to plan 3. 

The models I'll be looking at are GPT 5.6 Sol, Luna, Grok 4.5, potentially Opus (Fable would be interesting — but I do have other work and can't blitz usage) and then small models will be Qwen 3.6 27B and Gemma 4 — possibly the small 12B — this is where I'd love to look at a fine-tune, but time.

5.6 is currently doing the daily scan for unstructured data as we speak.

I'll update on the historic replays and their outcomes from the ones we've run so far and how we've managed the forecasting and the small amounts of unstructured data we've tried to inject on certain gameweeks.