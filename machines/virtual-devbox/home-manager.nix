{ impermanence, config, inputs, pkgs, ... }:

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
          ../../modules/home-manager/alacritty.nix
          ../../modules/home-manager/background.nix
          ../../modules/home-manager/git.nix
          ../../modules/home-manager/i3.nix
          #   ../../modules/home-manager/picom.nix
          ../../modules/home-manager/polybar.nix
          ../../modules/home-manager/vscode.nix
          ../../modules/home-manager/xdg.nix
          ../../modules/home-manager/zsh
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

        features = {
          alacritty.enable = true;
          git.enable = true;
          vscode.enable = true;
          xdg.enable = true;
          zsh.enable = true;
          background.enable = true;
          i3.enable = true;
          #   picom.enable = true;
          polybar.enable = true;
        };

        home.persistence."/nix/persist/${cfg.home.homeDirectory}" = {
          directories = [ ".ssh" ];
          allowOther = true;
        };
      };
    };
  };
}
