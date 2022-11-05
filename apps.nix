{
  perSystem = { pkgs, ... }: {
    apps = {
      default = { };

      install = {
        type = "app";
        program = pkgs.callPackage ./bootstrap/install.nix { };
      };

      lint = {
        type = "app";
        program = pkgs.writeShellApplication {
          name = "lint-app";
          runtimeInputs = with pkgs; [ coreutils deadnix statix ];
          text = ''
            deadnix --fail "$@" && printf '\e[32m%s\e[0m\n' "Deadnix succeeded!"
            statix check "$@" 2>/dev/null && printf '\e[32m%s\e[0m\n' "Statix succeeded!"
          '';
        };
      };

      terra = {
        type = "app";
        program = pkgs.writeShellApplication {
          name = "terra-app";
          runtimeInputs = with pkgs; [ coreutils execline.bin terraform ];
          # TODO: As long as we cannot somehow add the state file to git, I do not see a way to make this script independent of the machines directory.
          # This means I will need to always run this app in the root directory.
          text = ''
            trap "rm -f machines/config.tf.json" EXIT
            nix build .#terra -o machines/config.tf.json
            terraform -chdir=machines init
            terraform -chdir=machines apply
          '';
        };
      };
    };
  };
}
