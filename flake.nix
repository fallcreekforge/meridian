{
  description = "Meridian Rust development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { nixpkgs, fenix, ... }:
    let
      systems = [
        "aarch64-darwin"
        "aarch64-linux"
        "x86_64-darwin"
        "x86_64-linux"
      ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
    in
    {
      devShells = forAllSystems (
        system:
        let
          pkgs = import nixpkgs {
            inherit system;
          };
          rustToolchain = fenix.packages.${system}.complete.withComponents [
            "cargo"
            "clippy"
            "rust-src"
            "rustc"
            "rustfmt"
          ];
          clippyConfDir = pkgs.linkFarm "meridian-clippy-configuration" {
            "clippy.toml" = ./clippy.toml;
          };
        in
        {
          default = pkgs.mkShell {
            packages = [
              rustToolchain
              fenix.packages.${system}.rust-analyzer
              pkgs.nushell
              pkgs.git
              pkgs.just
              pkgs.nixfmt
              pkgs.stdenv.cc
              pkgs.statix
              pkgs.cargo-deny
              pkgs.cargo-expand
              pkgs.cargo-fuzz
              pkgs.cargo-nextest
              pkgs.evcxr
              pkgs.taplo
            ];

            CARGO_NET_GIT_FETCH_WITH_CLI = "true";
            CLIPPY_CONF_DIR = "${clippyConfDir}";
            RUSTFMT = "${rustToolchain}/bin/rustfmt";
            TAPLO_CONFIG = "${./taplo.toml}";

            shellHook = ''
              # Make an interactive development shell Nushell by default. The
              # TTY check preserves `nix develop -c <command>` for automation.
              if [ -t 0 ] && [ -z "''${NU_VERSION:-}" ]; then
                exec nu
              fi
            '';
          };
        }
      );

      formatter = forAllSystems (system: (import nixpkgs { inherit system; }).nixfmt);
    };
}
