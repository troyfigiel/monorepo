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

    nix-pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur.url = "github:nix-community/nur";

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

      imports = [ ./packages ./hosts ./modules ./templates ];

      # TODO: This is a basic working config. I will need to figure out how to leverage the perSystem functionality better.
      perSystem = { pkgs, ... }: {
        apps = {
          default = {
            type = "app";
            program = pkgs.writeShellApplication {
              name = "deploy-my-network";
              # TODO: I should not hard code laptop and cloud-server here. How should I determine which hosts to deploy?
              text = ''
                deploy_host () {
                   printf '\e[33m%s\e[0m\n' "Deploying to $1" \
                   && nix run .#deploy "$1" \
                   && printf '\e[32m%s\e[0m\n' "Successful deployment to $1!" \
                   || printf '\e[31m%s\e[0m\n' "Failed deployment to $1!"
                }

                nix fmt
                nix flake check --keep-going || exit 1
                nix run .#infra
                deploy_host laptop
                deploy_host cloud-server
              '';
            };
          };

          deploy = {
            type = "app";
            program = pkgs.callPackage ./deploy.nix { };
          };

          bootstrap = {
            type = "app";
            program = pkgs.callPackage ./bootstrap.nix { };
          };

          infra = {
            type = "app";
            program = pkgs.writeShellApplication {
              name = "my-infrastructure";
              runtimeInputs = with pkgs; [ coreutils execline.bin terraform ];
              text = ''
                cd infrastructure || exit 1
                terraform init
                terraform apply
                terraform output -json > outputs.json
              '';
            };
          };
        };

        # TODO: I need to run touch $out for the linters, because builds need to have an output.
        # This feels hacky. Is it the only way? It seems I am not the only one to do so: https://github.com/kira-bruneau/flake-linter/blob/main/lib/make-flake-linter/default.nix
        checks = {
          deadnix = pkgs.runCommand "check-deadnix" {
            buildInputs = [ pkgs.deadnix ];
          } ''
            deadnix --fail ${./.}
            touch $out
          '';

          statix =
            pkgs.runCommand "check-statix" { buildInputs = [ pkgs.statix ]; } ''
              statix check ${./.} 2>/dev/null
              touch $out
            '';

          # TODO: Nix-linter can not properly interpret ./${host}, which is why I need to exclude this one file.
          # TODO: Which linters are good? Try them out for a while to see what I prefer.
          nix-linter = pkgs.runCommand "check-nix-linter" {
            buildInputs = [ pkgs.findutils pkgs.nix-linter ];
          } ''
            find ${./.} -type f -name '*.nix' \
                 -not -path ${./.}/hosts/default.nix \
                 -print0 \
                 | xargs -0 nix-linter
            touch $out
          '';

          # TODO: Nix-linter can not properly interpret ./${host}, which is why I need to exclude this one file.
          # TODO: Which linters are good? Try them out for a while to see what I prefer.
          nixfmt = pkgs.runCommand "check-nixfmt" {
            buildInputs = [ pkgs.findutils pkgs.nixfmt ];
          } ''
            find ${./.} -type f -name '*.nix' \
                 -print0 \
                 | xargs -0 nixfmt -c
            touch $out
          '';
        };

        formatter = pkgs.writeShellApplication {
          name = "my-formatter";
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
