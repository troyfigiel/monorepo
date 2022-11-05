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
            trap "rm -f infrastructure/config.tf.json" EXIT
            nix build .#infrastructure -o infrastructure/config.tf.json
            terraform -chdir=infrastructure init
            terraform -chdir=infrastructure apply
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
