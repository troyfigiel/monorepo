{
  description = "Monorepo for Troy's Nix-builds";

  # We only follow nixpkgs explicitly, because pulling in different versions
  # will bloat the build process quite a bit.
  # Not following inputs might be better if you want full compatibility?
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    emacs-overlay = {
      url = "github:nix-community/emacs-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-parts.url = "github:hercules-ci/flake-parts";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    impermanence.url = "github:nix-community/impermanence";

    simple-nixos-mailserver = {
      url = "gitlab:simple-nixos-mailserver/nixos-mailserver/nixos-22.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, ... }@inputs:
    let inherit (inputs.flake-parts.lib) mkFlake;
    in mkFlake { inherit self; } {
      systems = [ "x86_64-linux" "aarch64-linux" ];

      imports = [
        ./bootstrap/flake-module.nix
        ./hosts/flake-module.nix
        ./infrastructure/flake-module.nix
        ./modules/flake-module.nix
      ];

      perSystem = { system, pkgs, ... }: {
        legacyPackages = import inputs.nixpkgs {
          inherit system;
          config.allowUnfreePredicate = pkg:
            builtins.elem (inputs.nixpkgs.lib.getName pkg) [
              "skypeforlinux"
              "steam"
              "steam-original"
              "steam-run"
            ];

          # Software that is not built for aarch64 does seem to work fine.
          # TODO: Does it make sense setting this for x86_64 systems as well?
          config.allowUnsupportedSystem = true;
          overlays = [
            inputs.emacs-overlay.overlay
            (import ./packages/overlay.nix)
            (import ./website/overlay.nix)
            (import ./modules/home-manager/my/emacs/tf/overlay.nix)
          ];
        };

        apps = {
          default = {
            type = "app";
            program = pkgs.writeShellApplication {
              name = "deploy-my-network";
              # TODO: I should not hard code laptop and cloud-server here. How should I determine which hosts to deploy?
              text = ''
                deploy_host () {
                   printf '\e[33m%s\e[0m\n' "Deploying to $1" \
                   && nix run .#hosts "$1" \
                   && printf '\e[32m%s\e[0m\n' "Successful deployment to $1!" \
                   || printf '\e[31m%s\e[0m\n' "Failed deployment to $1!"
                }

                nix fmt
                nix flake check --keep-going || exit 1
                nix run .#infrastructure
                deploy_host laptop
                deploy_host cloud-server
              '';
            };
          };
        };
        # TODO: This is a basic working config. I will need to figure out how to leverage the perSystem functionality better.
        # TODO: I need to run touch $out for the linters, because builds need to have an output.
        # This feels hacky. Is it the only way? It seems I am not the only one to do so: https://github.com/kira-bruneau/flake-linter/blob/main/lib/make-flake-linter/default.nix
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

          nix-linter = pkgs.runCommand "checks-nix-linter" {
            buildInputs = [ pkgs.findutils pkgs.nix-linter ];
          } ''
            find ${./.} -type f -name '*.nix' -print0 | xargs -0 nix-linter
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
