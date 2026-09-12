set shell := ["nu", "-c"]

fmt:
   cargo fmt --all -- --check

lint:
   cargo clippy --workspace --all-targets --all-features -- -D warnings

nix-fmt:
   nixfmt --check flake.nix

nix-lint:
   statix check flake.nix

test:
   cargo test --workspace --all-features

toml-fmt:
   taplo format --check --config taplo.toml

check:
   cargo check --workspace --all-targets --all-features

ci: fmt lint nix-fmt nix-lint test toml-fmt

run *args:
   cargo run --package meridian-cli -- {{args}}
