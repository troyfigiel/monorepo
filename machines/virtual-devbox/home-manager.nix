{ impermanence, config, hmModules, inputs, pkgs, ... }:

{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs impermanence; };

    users = {
      troy = let cfg = config.home-manager.users.troy;
      in {
        imports = [
          inputs.impermanence.nixosModules.home-manager.impermanence
          hmModules.alacritty
          hmModules.background
          hmModules.emacs
          hmModules.git
          hmModules.i3
          #   ../../modules/home-manager/picom.nix
          hmModules.polybar
          hmModules.rofi
          hmModules.vscode
          hmModules.xdg
          hmModules.zsh
        ];

        home = {
          homeDirectory = "/home/troy";
          username = "troy";
          sessionVariables = { EDITOR = "vim"; };
          stateVersion = "22.05";
        };

        fonts.fontconfig.enable = true;

        programs.home-manager.enable = true;
        programs.direnv = {
          enable = true;
          nix-direnv.enable = true;
        };
        programs.dircolors.enable = true;

        my = {
          alacritty.enable = true;
          git.enable = true;
          emacs.enable = true;
          vscode.enable = true;
          xdg.enable = true;
          zsh.enable = true;
          background.enable = true;
          i3.enable = true;
          #   picom.enable = true;
          polybar.enable = true;
          rofi.enable = true;
        };

        home.persistence."/nix/persist/${cfg.home.homeDirectory}" = {
          directories = [ ".ssh" ];
          allowOther = true;
        };
      };
    };
  };
}
