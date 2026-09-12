# Contributing

Enter the pinned Nushell environment and run the repository gate:

```nu
nix develop
just ci
```

Keep changes small and preserve the dependency direction in [ARCHITECTURE.md](ARCHITECTURE.md).
Protocol expansions require security review. Architectural contract changes require a concise ADR.
Never use real credentials in development or tests.
