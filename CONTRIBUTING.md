# Contributing

Enter the pinned Nushell environment and run the repository gate:

```nu
nix develop
just ci
```

`just ci` runs the flake checks used by Hercules CI, including the native Linux package, the
Windows x86-64 GNU portability package, and the repository format, lint, and test recipes. The
GitHub Actions Windows job is complementary native MSVC coverage; it does not produce a release
artifact. Keep Hercules CI agent, cache, and signing credentials out of the repository.

Keep changes small and preserve the dependency direction in [ARCHITECTURE.md](ARCHITECTURE.md).
Update its current-state diagram when a PR changes components, dependencies, or runtime data flow.
Protocol expansions require security review. Architectural contract changes require a concise ADR.
Never use real credentials in development or tests.
