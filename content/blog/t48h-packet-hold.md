---
title: T-48h data packet review
slug: "t48h-packet-hold"
date: 2026-08-19
draft: false
description: "Early T-48h bind still validates the Haaland-in side, and still loses on score to the no-Haaland robust arm."
---

I ran the data packets early today and will be having more processed each day ahead of Friday.

The more I run, the more I want to post multiple teams to explore each of the different possibilities of where to weight the points. The output below breaks down three different teams set ups with the scores being the EP for the first 6 game weeks. It actually puts the no Halaand squad ahead by 17 points, which is why i probably will run a few different versions of this and then try and break out the decision making from it.

The expected points is the deciding factor for the captain/vice captain decision and its held Bruno as captain the last week.

Below is the exact agent output.

### Agent output: T-48h initial-squad checkpoint

> The T-48h packet is sealed locally, about seven hours early.
>
> New bind: 3b6e5ea1… (T-48h, observed 19 Aug 11:52 UK). Still
> live_faithful_degraded; approval blocked. Full artefacts are under
> reports/live/2026-27/initial-squad/T-48h/ (gitignored). The committed
> summary is ready at reports/strategy-research/packets/T-48h.json but
> not pushed.
>
> Does it change the 15? No. The current Haaland-in side still validates
> on the new packet (Bruno C, same 3-4-3, bank £0.5m). Host scores:
> human_reference 238.61, robust 234.32. The new no-Haaland robust arm is
> still ahead at 255.88 (Rice / Semenyo / Rogers / Anderson; no Haaland).
> Same pattern as 11 Aug.
>
> Tzolis is in this packet and looks worse than Harry Wilson: EP 2.19 /
> start_p 0.41 vs 3.67 / 0.73. Do not swap him in on this score.
>
> Today's X digest - nothing that should move the side.


| Signal                                   | Vs this 15                               | Call                |
| ---------------------------------------- | ---------------------------------------- | ------------------- |
| Haaland vs Bruno                         | Packet still Bruno 6.37 > Haaland 5.74   | Keep Bruno (C)      |
| Rogers minutes debate                    | Not in the 15; is in the new robust arm  | Watch, not a change |
| Doku calf 75%                            | Official d; not in the packet universe   | Ignore              |
| Nørgaard 25%                             | Not in the 15                            | Ignore              |
| Timber training / White-Mosquera GW2     | We have no Arsenal DEF                   | GW2 only            |
| Cheap DEF / DefCon                       | Already have Van Hecke / Mitchell / Shaw | No change           |
| BB1 chatter                              | Diop / van Ewijk still non-playing       | Hold chips          |
| Gross off pens / Hinshelwood / Tavernier | One-account or punts                     | No                  |


> Warning: this used the official id T-48h. The 18:30 Windows job must
> not recapture the same id with different bytes - it will fail closed.
> Treat tonight as already done, or use a different id.
>
> Finished Run T-48h initial-squad decision checkpoint
>
> The early T-48h checkpoint finished successfully. Packet 3b6e5ea1… is
> on disk; the current Haaland-in 15 still validates and still does not
> beat the no-Haaland robust arm.



## Current advisory XI (unchanged on T-48h)

Verbruggen; Van Hecke, Mitchell, Shaw; B.Fernandes, Gibbs-White,
E.Le Fée, Wilson; Haaland, João Pedro, Thiago.

C / VC: Bruno / Haaland. Bench: Dubravka, Xhaka, Diop, van Ewijk.
£99.5m / £0.5m ITB.