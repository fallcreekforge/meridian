# Architecture

This repository implements Meridian software that runs in a customer's environment. Proprietary
Meridian Cloud code is outside this repository.

```text
Platform credential
       ↓
local Meridian client
       ↓
platform API
       ↓
normalize / filter / validate
       ↓
versioned sync protocol

════════ TRUST BOUNDARY ════════

Meridian Cloud
```

The protocol is the auditable boundary: it has no credential type, arbitrary value bag, or
unrestricted JSON field.

## Workspace

```text
meridian-types ◄── meridian-sync-protocol ◄── meridian-local
       ▲
       └── meridian-platform ◄─────────────── meridian-local
                    ▲
                    └──────────────────────── meridian-steam

meridian-credential-store ◄── meridian-platform
            ▲
            ├──────────────── meridian-steam
            └──────────────── meridian-local

meridian-cli
```

Cargo dependencies point left. `meridian-local` depends on the platform-neutral contract, not a
specific integration. Platform crates adapt typed capabilities to that contract. The CLI currently
contains only command handling and is not connected to `SyncEngine`.
