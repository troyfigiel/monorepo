{ config, inputs, impermanence, ... }:

{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs impermanence; };
    users.troy = {
      imports = [ inputs.impermanence.nixosModules.home-manager.impermanence ];
      home = {
        username = "troy";
        homeDirectory = "/home/troy";
        stateVersion = "22.05";

        persistence."/nix/persist/${config.home-manager.users.troy.home.homeDirectory}" =
          {
            directories = [ ".ssh" ];
            allowOther = true;
          };
      };

      fonts.fontconfig.enable = true;

      programs = {
        # I need to explicity enable bash to have a working direnv integration outside of Emacs.
        bash.enable = true;
        dircolors.enable = true;

        direnv = {
          enable = true;
          nix-direnv.enable = true;
        };
        home-manager.enable = true;
      };
    };
  };
}
