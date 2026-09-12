# 0003: Platform-neutral local core

- Status: accepted
- Date: 2026-09-11

## Decision

Local orchestration depends on the typed `meridian-platform` contract. Platform-specific crates
adapt to it, while sync-protocol platform variants remain explicit and security-reviewed.

## Consequences

Adding a platform requires an adapter and an explicit protocol change; it does not change the
orchestration contract.
