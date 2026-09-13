# Repository instructions

- Use Nushell; `nix develop` starts the pinned environment.
- Meridian is the product; this repository implements Meridian Client.
- Make the smallest coherent change and avoid speculative dependencies or abstractions.
- Preserve the dependency graph in `ARCHITECTURE.md` and keep cloud implementation out of this
  repository.
- Update the current-state diagram in the same PR as any component, dependency, or runtime-flow
  change.
- Keep cross-repository product and domain decisions in `fallcreekforge-docs`.
- For external documentation, roadmap, sprint, prioritization, or sequencing work, read
  `EXTERNAL-CONTEXT.md` and the relevant linked context when available.
- Read `SECURITY.md` before changing credentials, protocols, transports, logging, or the
  customer-to-cloud trust boundary.
- Update an ADR only when an architectural contract changes.
- Follow crate-local `AGENTS.md` files for boundary-specific rules.

Run before handoff:

```nu
just fmt
just lint
just test
just ci
```
