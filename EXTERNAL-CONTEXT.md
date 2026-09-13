# External context

Some Meridian Client development tasks need documents owned by another repository. This repository
can expose those documents through local symlinks without copying or versioning them here.

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

## Check local context

Run the optional, read-only audit after changing repository instructions or external-context links:

```nu
just agent-context-audit
```

The audit reports repository instruction-chain sizes and validates every symlink whose target is
outside this repository. It remains separate from `just ci` because external context is a local
development aid, not a product requirement.
