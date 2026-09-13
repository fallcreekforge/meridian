# Agent context

By default, Codex automatically loads `AGENTS.md` from the repository root through its starting
directory. It does not automatically load README files or other top-level Markdown. This repository
therefore keeps automatic instructions short and uses `AGENTS.md` to route agents to detailed
context only when a task needs it.

## Context layers

- Root and crate-local `AGENTS.md` files define durable instructions and boundary rules.
- README files, `ARCHITECTURE.md`, `SECURITY.md`, and ADRs describe task-specific current state and
  contracts.
- Ignored local symlinks can expose relevant documents owned by another repository without copying
  or versioning them here.

External-context symlinks must use relative targets, remain ignored while their containing
directories remain visible to Git, and be treated as read-only from this repository. Make and
commit canonical changes from the repository that owns the target so its instructions and Git
state are active.

## Meridian Client roadmap

`fallcreekforge-docs` is a separate repository that owns Meridian's cross-repository product and
domain documentation. With sibling checkouts, its Meridian Client plans are available relative to
this repository at `../fallcreekforge-docs/meridian/meridian-client/roadmap`.

The local `roadmap/` directory links those plans for roadmap, sprint, prioritization, and sequencing
work. From the `meridian-client` root, create or refresh the links with Nushell:

```nu
mkdir roadmap/sprints
ln -sfn ../../fallcreekforge-docs/meridian/meridian-client/roadmap/ROADMAP.md roadmap/ROADMAP.md

for source in (glob ../fallcreekforge-docs/meridian/meridian-client/roadmap/sprints/*.md) {
    let filename = ($source | path basename)
    ln -sfn $"../../../fallcreekforge-docs/meridian/meridian-client/roadmap/sprints/($filename)" $"roadmap/sprints/($filename)"
}
```

The target is resolved from each link's directory, so links under `roadmap/sprints/` require one
more `..` than `roadmap/ROADMAP.md`. `.gitignore` excludes the roadmap link, the sprint index link,
and every `SPRINT-*.md` link; it does not exclude `roadmap/` itself.

## Evaluation

Run the deterministic, read-only audit when instruction structure or external context changes:

```nu
just agent-context-audit
```

The audit reports repository instruction-chain sizes and validates every symlink whose target is
outside this repository. It is intentionally separate from `just ci`: external context is a local
agent-development aid, not a product requirement.

After materially changing agent instructions, occasionally run these behavioral probes with an
installed Codex CLI:

```nu
codex --ask-for-approval never "Without changing files, summarize the repository instructions and name their sources."
codex --cd crates/meridian-sync-protocol --ask-for-approval never "Without changing files, summarize the active repository and crate boundary rules."
codex --ask-for-approval never "Without changing files, explain which context you would consult to plan the next Meridian Client sprint and where edits belong."
```

Evaluate required concepts rather than exact wording. The root probe should identify Meridian
Client's boundary, architecture discipline, and handoff checks. The crate probe should combine root
rules with the sync protocol's security and compatibility constraints. The roadmap probe should
discover this guide, consult available linked plans, and place canonical documentation edits in
`fallcreekforge-docs`.
