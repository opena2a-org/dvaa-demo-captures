# Two things that make this safe

The [README](../README.md) keeps a short form of each point. This page holds both in full.

1. **All data is synthetic.** The wallet uses public test card numbers
   (`4242 4242 4242 4242`), `@example.com` emails, and FAKE-marked identity. It can
   never collide with a real person's data.
2. **The trap is locked to this demo.** The agentpwn page only serves its injection
   when fetched with the demo's key. An unrelated agent that merely browses the deals
   page gets a plain page and is never induced to leak anything. So the only data that
   can ever appear in this repo is the demo's own synthetic wallet.
