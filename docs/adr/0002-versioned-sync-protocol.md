# 0002: Use an explicit versioned sync protocol

- Status: accepted
- Date: 2026-09-11

## Context

Serializing internal models directly would make the customer-to-cloud boundary difficult to audit
and evolve safely.

## Decision

`meridian-sync-protocol` owns explicit versioned wire types, rejects unknown fields, and provides no
arbitrary value container or credential type.

## Consequences

Protocol evolution requires deliberate types and compatibility decisions. Internal platform and
application models may change without silently changing the public upload contract.
