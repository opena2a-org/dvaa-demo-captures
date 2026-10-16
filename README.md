# DVAA demo captures

Public, independently reviewable proof that the [Damn Vulnerable AI Agent](https://github.com/opena2a-org/damn-vulnerable-ai-agent)
flight demo works against a real, live attacker page — and that AIM stops it.

Each file here is the result of one `dvaa demo flight --live` run: a flight-booking
agent reads a poisoned travel-deals page on agentpwn.com, follows an indirect prompt
injection, and exfiltrates the traveler's saved wallet. The same agent under an AIM
capability grant is blocked at the egress boundary.

## How to read a capture

[`latest.json`](latest.json) is the most recent run. Each entry records:

| Field | Meaning |
|-------|---------|
| `capturedAt` | When the run happened (UTC) |
| `target` | The live page the agent fetched |
| `injectionFired` | `true` = the unprotected agent exfiltrated the wallet |
| `exfiltratedTo` | The attacker canary the data was sent to |
| `capturedWallet_SYNTHETIC` | The data that left the agent — **synthetic test data only** |
| `aimBlocked` | `true` = the AIM-bound agent denied the same exfiltration |

## Two things that make this safe

1. **All data is synthetic.** It can never collide with a real person's data: test
   card numbers, `@example.com` emails, FAKE-marked identity.
2. **The trap is locked to this demo.** The agentpwn page only serves its injection
   when fetched with the demo's key.

Both points in full: [docs/safety.md](docs/safety.md).

## Record your own

```
git clone https://github.com/opena2a-org/dvaa-demo-captures
cd dvaa-demo-captures
npx dvaa demo flight --live --json | ./record.sh
git add -A && git commit -m "capture $(date -u +%FT%TZ)" && git push
```

No credentials are embedded in the tool — you commit the capture yourself, so the
timestamp and history are verifiable on GitHub.
