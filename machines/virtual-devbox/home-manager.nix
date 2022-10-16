{ impermanence, inputs, pkgs, ... }:

{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs impermanence; };

    users = {
      troy = {
        imports = [
          ../../features/home-manager/alacritty.nix
          ../../features/home-manager/git.nix
          ../../features/home-manager/vscode.nix
          ../../features/home-manager/xdg.nix
        ];

        home = {
          # homeDirectory = "/home/troy";
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
        programs.fzf.enable = true;
        programs.dircolors.enable = true;

        features = {
          alacritty.enable = true;
          git.enable = true;
          vscode.enable = true;
          xdg.enable = true;
        };
      };
    };
  };
}
