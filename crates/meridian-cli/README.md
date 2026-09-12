# meridian-cli

Builds the `meridian` command-line interface.

The crate owns argument parsing and terminal output. `status` and `sync` currently report that no
platform connection is configured. Once synchronization is wired to concrete dependencies,
reusable behavior belongs in `meridian-local`, not this crate.
