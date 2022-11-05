{
  perSystem = { pkgs, ... }: {
    apps = {
      default = { };

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
            trap "rm -f config.tf.json" EXIT
            nix build ..#infrastructure -o config.tf.json
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
