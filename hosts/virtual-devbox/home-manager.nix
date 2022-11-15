{ impermanence, config, hmModules, inputs, ... }:

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
          hmModules.home
          hmModules.i3
          #   ../../modules/home-manager/picom.nix
          hmModules.polybar
          hmModules.rofi
          hmModules.xdg
          hmModules.zsh
        ];

        my = {
          alacritty.enable = true;
          git.enable = true;
          emacs.enable = true;

          directories = [ "documents" "downloads" "projects" ];

          home = {
            enable = true;
            onLaptop = false;
          };

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
