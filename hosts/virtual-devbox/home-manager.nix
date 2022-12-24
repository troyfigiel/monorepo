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
          hmModules.background
          hmModules.emacs
          hmModules.git
          hmModules.home
          hmModules.i3
          # hmModules.picom
          hmModules.rofi
          hmModules.xdg
        ];

        my = {
          git.enable = true;
          emacs.enable = true;

          directories = [ "documents" "downloads" "projects" ];

          home = {
            enable = true;
            onLaptop = false;
          };

          background.enable = true;
          i3.enable = true;
          #   picom.enable = true;
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
