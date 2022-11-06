{
  perSystem = { pkgs, ... }: {
    apps = {
      default = {
        type = "app";
        program = pkgs.writeShellApplication {
          name = "deploy-my-network";
          text = ''
            nix run .#infra

            deploy_host () {
               printf '\e[33m%s\e[0m\n' "Deploying to $1" \
               && nix run .#deploy "$1" \
               && printf '\e[32m%s\e[0m\n' "Successful deployment to $1!" \
               || printf '\e[31m%s\e[0m\n' "Failed deployment to $1!"
            }

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

      lint = {
        type = "app";
        program = pkgs.writeShellApplication {
          name = "my-linter";
          runtimeInputs = with pkgs; [ coreutils deadnix statix ];
          text = ''
            deadnix --fail "$@" && printf '\e[32m%s\e[0m\n' "Deadnix succeeded!"
            statix check "$@" 2>/dev/null && printf '\e[32m%s\e[0m\n' "Statix succeeded!"
          '';
        };
      };
    };
  };
}
