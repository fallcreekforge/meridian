# Meridian

Meridian is a Fall Creek Forge product for independent game studios. This repository contains the
open-source client that runs in studio-controlled infrastructure.

The client keeps platform credentials local and produces an explicit, auditable payload for
Meridian Cloud. The current implementation defines the core types, interfaces, and local
orchestration. No platform or cloud network client is implemented.

## Development

The pinned Fenix environment opens Nushell and provides the project tools:

```nu
nix develop
just ci
cargo run --package meridian-cli -- --version
cargo run --package meridian-cli -- status
cargo run --package meridian-cli -- sync
```

`status` and `sync` report the current unconfigured state.

See [ARCHITECTURE.md](ARCHITECTURE.md), [SECURITY.md](SECURITY.md), and
[CONTRIBUTING.md](CONTRIBUTING.md) for repository-specific details.

## License

Licensed under the [Apache License 2.0](LICENSE). See [NOTICE](NOTICE) for attribution.
