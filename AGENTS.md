# Repository instructions

- Use Nushell; `nix develop` starts the pinned environment.
- Make the smallest coherent change and avoid speculative dependencies or abstractions.
- Preserve the dependency graph in `ARCHITECTURE.md` and keep cloud implementation out of this
  repository.
- Update an ADR only when an architectural contract changes.
- Follow crate-local `AGENTS.md` files for boundary-specific rules.

Run before handoff:

```nu
just fmt
just lint
just test
just ci
```
