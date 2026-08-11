---
title: "Designing the engine alongside agents"
slug: "designing-the-engine-with-agents"
date: 2026-08-03
draft: false
description: "What building the decision laboratory with agents has taught so far — provenance gates, unstructured data, early modelling mistakes, and dialling in for GW1–6."
---

The key issues so far have been in designing the engine alongside agents. I have now got this set up largely as I want it, at least directionally.

The datasets have been part of the challenge. I mentioned provenance of data as key early on, and that led the agents down a very strict path of not enabling certain datasets until they were verified and authorised for use. 

I have been changing some of the methods for how we use the data. I have maintained the core deterministic engine that evaluates the gathered statistics. The harder part has been the unstructured side. Early on I put too much emphasis on provenance there as well, and that led to limited data coming in from automated agent search each day. I am now looking at this as gathering as much as possible, submitting it to the ledger, and letting an agent use that alongside its own search to make decisions on the starting team for GW1.

An absence of Haaland in early line-ups was an exmaple of the system not drawing on the data properly. World Cup fatigue was over-indexed (which was a passing includsion) and I am feeling that is not really worth including as a hard prior. It is a tiny detail amongst a lot of more significant data and was actually pushign the model not to select Haaland in most cases, which is not optimal! The model did not properly consider opportunity cost, but now with better data coming in, it should hopefully understand elements of this better.

I am currently planning around GW1–6, with the agents proposing the final team selections and updates coming in daily after the research agent has pulled in new data. I will be inputting the team, but I am trying to dial this in as much as I can now so I do not doubt its choices further down the line, and so I know I have given it the best chance to make a decision. I still feel some way from that, but there are still about three weeks to season start.