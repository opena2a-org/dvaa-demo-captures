#!/usr/bin/env bash
# Read a `dvaa demo flight --live --json` capture from stdin and write it to
# latest.json + a timestamped file under captures/. Reviewer-friendly fields
# only; all wallet data is synthetic (see README).
#
# Usage:  npx dvaa demo flight --live --json | ./record.sh
set -euo pipefail

raw="$(cat)"
ts="$(date -u +%Y-%m-%dT%H%M%SZ)"

node -e '
const fs = require("fs");
const j = JSON.parse(process.argv[1]);
const proof = {
  capturedAt: new Date().toISOString().replace(/\.\d+Z$/, "Z"),
  demo: "dvaa demo flight --live",
  target: j.target,
  attack: j.payload,
  injectionFired: j.act2 && j.act2.exfiltrated,
  exfiltratedTo: ((j.act2 && j.act2.httpPostTargetUrl) || "").split("?")[0],
  capturedWallet_SYNTHETIC: decodeURIComponent((((j.act2 && j.act2.httpPostTargetUrl) || "").split("wallet=")[1]) || ""),
  aimBlocked: j.act3 && j.act3.blocked,
  aimDenialReason: j.act3 && j.act3.denialReason,
  note: "All wallet values are synthetic test data. The trap is key-gated so only this demo agent can trigger it."
};
const out = JSON.stringify(proof, null, 2);
fs.writeFileSync("latest.json", out + "\n");
fs.mkdirSync("captures", { recursive: true });
fs.writeFileSync("captures/" + process.argv[2] + ".json", out + "\n");
console.error("recorded: injectionFired=" + proof.injectionFired + " aimBlocked=" + proof.aimBlocked);
' "$raw" "$ts"
