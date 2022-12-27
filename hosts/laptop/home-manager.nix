{ hmModules, impermanence, inputs, ... }:

{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs impermanence; };

    users = {
      troy = {
        imports = [
          inputs.impermanence.nixosModules.home-manager.impermanence
          hmModules.dunst
          hmModules.emacs
          hmModules.firefox
          hmModules.git
          hmModules.gpg
          hmModules.home
          hmModules.i3
          hmModules.messenger
          hmModules.pass
          hmModules.picom
          hmModules.rofi
          hmModules.xdg
        ];

        my = {
          dunst.enable = true;
          firefox = {
            enable = true;
            defaultBrowser = true;
          };
          git.enable = true;
          gpg.enable = true;
          home = {
            enable = true;
            onLaptop = true;
          };
          i3.enable = true;
          messenger.enable = true;
          pass.enable = true;
          picom.enable = true;
          directories = [ "documents" "downloads" "projects" ];
          emacs.enable = true;
          rofi.enable = true;
        };
      };
    };
  };
}
