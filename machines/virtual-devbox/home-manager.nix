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
          ../../features/home-manager/alacritty.nix
          ../../features/home-manager/background.nix
          ../../features/home-manager/git.nix
          ../../features/home-manager/i3.nix
          #   ../../features/home-manager/picom.nix
          ../../features/home-manager/polybar.nix
          ../../features/home-manager/vscode.nix
          ../../features/home-manager/xdg.nix
          ../../features/home-manager/zsh
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
