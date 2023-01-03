{
  description = "Monorepo for Troy's Nix-builds";

  # We only follow nixpkgs explicitly, because pulling in different versions
  # will bloat the build process quite a bit.
  # Not following inputs might be better if you want full compatibility?
  inputs = {
    deploy-rs = {
      url = "github:serokell/deploy-rs";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    emacs-overlay = {
      url = "github:nix-community/emacs-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-parts.url = "github:hercules-ci/flake-parts";

    hardware.url = "github:nixos/nixos-hardware";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    impermanence.url = "github:nix-community/impermanence";

    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    simple-nixos-mailserver = {
      url = "gitlab:simple-nixos-mailserver/nixos-mailserver/nixos-22.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" "aarch64-linux" ];

      imports = [ ./machines/flake-module.nix ./templates/flake-module.nix ];

      perSystem = { system, pkgs, ... }: {
        legacyPackages = import inputs.nixpkgs {
          inherit system;
          config.allowUnfreePredicate = pkg:
            builtins.elem (inputs.nixpkgs.lib.getName pkg) [ "skypeforlinux" ];

          # TODO: Does it make sense setting this for x86_64 systems as well? Software that is not
          # built for aarch64 does seem to work fine.
          config.allowUnsupportedSystem = true;
          overlays = [
            inputs.deploy-rs.overlay
            inputs.emacs-overlay.overlay
            (_final: prev: {
              sddm-sugar-candy = prev.callPackage ./packages/sddm-sugar-candy {
                inherit (prev.libsForQt5) qtgraphicaleffects;
                background = ./machines/assets/nixos.jpg;
              };
              tdda = prev.callPackage ./packages/tdda {
                inherit (prev.python3Packages) buildPythonPackage pandas;
              };
              tf-emacs = prev.callPackage ./emacs {
                inherit (prev.python3Packages) jupytext;
              };
              website = prev.callPackage ./website { };
            })
          ];
        };

        apps = {
          default = {
            type = "app";
            program = pkgs.writeShellApplication {
              name = "monorepo";
              runtimeInputs = with pkgs; [ nixos-rebuild deploy-rs ];
              text = ''
                if [[ "$EUID" != 0 ]]; then
                   echo 'Root privileges are needed to activate the local NixOS configuration.'
                   exit 1
                fi
                nix fmt
                nix flake check --keep-going || exit 1
                nix run .#infrastructure
                nixos-rebuild switch --flake .
                deploy . -s
              '';
            };
          };
        };

        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            black
            deploy-rs
            nil
            nixfmt
            python3
            python3Packages.flake8
            python3Packages.python-lsp-server
            texlive.combined.scheme-full
          ];
        };

        # TODO: I need to run touch $out for the linters, because builds need to have an output.
        # This feels hacky. Is it the only way? It seems I am not the only one to do so:
        # https://github.com/kira-bruneau/flake-linter/blob/main/lib/make-flake-linter/default.nix
        checks = {
          deadnix = pkgs.runCommand "checks-deadnix" {
            buildInputs = [ pkgs.deadnix ];
          } ''
            deadnix --fail ${./.}
            touch $out
          '';

          statix = pkgs.runCommand "checks-statix" {
            buildInputs = [ pkgs.statix ];
          } ''
            statix check ${./.} 2>/dev/null
            touch $out
          '';

          nixfmt = pkgs.runCommand "checks-nixfmt" {
            buildInputs = [ pkgs.findutils pkgs.nixfmt ];
          } ''
            find ${./.} -type f -name '*.nix' -print0 | xargs -0 nixfmt -c
            touch $out
          '';
        };

        formatter = pkgs.writeShellApplication {
          name = "formatter-nixfmt";
          runtimeInputs = [ pkgs.findutils pkgs.nixfmt ];
          text = ''
            find "$@" -type f -name '*.nix' \
                 -not -path '**/.git/*' \
                 -print0 \
                 | xargs -0 nixfmt
          '';
        };
      };
    };
}
