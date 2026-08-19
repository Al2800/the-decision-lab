---
title: Agent thinking on the team choice
slug: "advisory-team-change-decision-structure"
date: 2026-08-18
draft: false
description: "The first real named-15 change in the daily loop, and how the decision structure sits against the deterministic and robust arms."
---

I've been more involved in this loop than I was hoping. It's kind of crossed over with my own interest in developing a team alongside how the agent works across it. I was going to post some of these agent traces essentially around how it's been making the decision and what information it's using. You can see somewhere below from about 10 days out, I was looking at trying to increase the amount of news going into the system. What's happened is we've had a base of players that haven't been influenced by me, just from what the data has said and what the news has influenced, albeit I've arranged the sources! And that's stabilized since we got to that point. Additionally, there's been a lot back and forth around Haaland, using various preseason markers particulalry the Community Shield as a reference point as to whether he'll be captain or not. It is still going between Bruno and Haaland for Captain and Vice. Still no chip deployed in game week one. The blow is an output from one of the agents. I'm just going to leave it as is, and I think I'll probably try and populate out some more of this with agent processes. People might find it useful for their own decision making as it comes back with some useful insights.

I've also been playing around with Grokbot as new agent release, which came out last week. I've been using it for some scheduled reviews across X to try and get more open-source intel to pass through into the system. It is pretty high-level, but some of it has been taken forward and used by the model, but nothing has changed the team at this point.



*****



The daily advisory loop ran the same named fifteen for a few days (Haaland, Bruno, Gabriel spine). Then on 12 August it moved. That is the interesting bit for me, less as a "better draft" claim and more as a look at how the decision is structured: what the deterministic / robust arms want, what the strategy agent overrides, and what it still cannot verify.

I am still the one who would enter any team. This is advisory.



## The change (12 Aug vs the sticky 8-11 side)

Out: Gabriel, Rogers, Szoboszlai, Ndiaye, Beto  
In: Van Hecke, Gibbs-White, E.Le Fée, Wilson, Thiago  

Captain flips to Bruno, Haaland to vice. Chip path still no GW1 chip.

From 12 August through 18 August the named fifteen has held again (Community Shield evidence updated the Haaland story; the 15 did not thrash).

## AI output: decision structure

The useful part of the briefing is not the player table. It is this shape: comparator arms, what was followed, what was overridden, what could not be verified.

### From the 12 Aug team diff (agent)

> Transfers (advisory)
> In: E.Le Fée, Gibbs-White, Thiago, Van Hecke, Wilson
> Out: Beto, Gabriel, Ndiaye, Rogers, Szoboszlai
>
> Captain: Haaland -> B.Fernandes
> Vice: B.Fernandes -> Haaland
>
> Packet numbers the agent used (bound weekly-2026-08-11; EP = expected points from the fixture audit, not raw xG - understat event rates were absent from this packet):
>
> - Bruno GW1 EP 6.37 / start_p 0.8554 -> captain
> - Haaland GW1 EP 5.74 / start_p 0.8148 -> vice
> - Haaland six-GW packet aggregate 34.44 (premium override support)
> - Semenyo (dropped for budget) GW1 EP 4.79 / start_p 0.8853
> - Bench enablers (why no BB1): Diop start_p 0.2571; van Ewijk 0.2991; Dubravka 0.7593
> - Playing DEF start_p: Van Hecke 0.8054; Mitchell 0.8069; Shaw 0.8469
> - Thiago start_p 0.8795; João Pedro 0.7450; Verbruggen 0.8319
>
> Comparator objectives (both no-Haaland):
>
> - Deterministic objective 244.24
> - Robust (selected arm) objective 240.72
>
> Chip path: still no GW1 chip; roll FT; WC / BB / TC held for later conditions
> Cost: £99.5m / £0.5m ITB
> Confidence: low (degraded odds/ratings/promoted priors/transfers/WC fatigue; no same-packet host rescore of this Haaland-in 15 yet)

### From a later hold briefing (18 Aug) - same structure, clearer after Community Shield

> Squad thesis:
> Keep the Haaland-in / Bruno-core 3-4-3 funded by cheap GK and promoted DEF enablers; CS confirms Haaland started, with planned early minutes rather than an injury exit.
>
> Same packet numbers still driving C/VC (unchanged quotes, not reinvented):
>
> - Bruno GW1 EP 6.37 / start_p 0.8554 vs Haaland 5.74 / 0.8148
> - Supporting XI EP samples: Gibbs-White 5.11; Wilson 3.67 / start_p 0.7342
> - Haaland own ~70.9% (bootstrap); João Pedro own ~59.6%
> - CS admitted claims: Haaland started; planned early-sub minutes role; Semenyo started; Saka bench-available
> - Minutes note: CS raises Haaland minutes risk qualitatively; agent does not invent a lower start_p; numeric xMins still unknown
>
> Where this differs from the deterministic / robust arms:
>
> - Deterministic (obj 244.24): no Haaland; Semenyo, Raya, Donnarumma, Matheus N., Beto, Calvert-Lewin
> - Robust selected (obj 240.72): no Haaland; Semenyo + Thiago + Obi
> - Followed: Van Hecke, Mitchell, Bruno, Gibbs-White, Le Fée, Wilson, João Pedro, Thiago from the robust/core set; Bruno captaincy
> - Overrode: drop Raya/Donnarumma/Semenyo/premium DEF stack to fund Haaland after CS started_match + planned-minutes context
> - Could not verify: same-packet host score for this Haaland-in 15; Spurs GK hierarchy; wider WC-returner minutes beyond CS
>
> Decision boundaries (compressed):
>
> - Premium inclusion: keep Haaland (reject no-Haaland comparator pathway for now)
> - Captaincy: Bruno C / Haaland VC (reject Haaland C on CS buzz alone)
> - Bench / BB: no BB1; Diop/van Ewijk are funding, not a playing 15
> - City mid: prefer Haaland over Semenyo in the 15
>
> Confidence: medium (CS evidence upgrade; packet still live_faithful_degraded)

## Current advisory XI (as held through 18 Aug)

Verbruggen; Van Hecke, Mitchell, Shaw; B.Fernandes, Gibbs-White, E.Le Fée, Wilson; Haaland, João Pedro, Thiago.

C / VC: Bruno / Haaland. Bench: Dubravka, Xhaka, Diop, van Ewijk. £99.5m / £0.5m ITB.

