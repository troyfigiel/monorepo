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
          hmModules.alacritty
          hmModules.background
          hmModules.dunst
          hmModules.emacs
          hmModules.firefox
          hmModules.git
          hmModules.gpg
          hmModules.home
          hmModules.i3
          hmModules.messenger
          hmModules.nvim
          hmModules.pass
          hmModules.picom
          hmModules.polybar
          hmModules.rofi
          hmModules.syncthing
          hmModules.vscode
          hmModules.xdg
          hmModules.zsh
        ];

        my = {
          alacritty.enable = true;
          background = {
            enable = true;
            wallpaperDirectory = "/nix/persist/home/troy/.wallpapers";
          };
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
          polybar.enable = true;
          syncthing.enable = true;
          vscode.enable = true;
          directories =
            [ "documents" "downloads" "projects" "audio" "pictures" "videos" ];
          emacs.enable = true;
          rofi.enable = true;
          nvim.enable = true;
          zsh.enable = true;
        };
      };
    };
  };
}