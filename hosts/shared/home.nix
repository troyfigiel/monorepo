{ inputs, impermanence, ... }:

{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs impermanence; };
    users.troy = {
      home = {
        username = "troy";
        homeDirectory = "/home/troy";
        stateVersion = "22.05";
      };

      fonts.fontconfig.enable = true;

      programs.home-manager.enable = true;
      programs.direnv = {
        enable = true;
        nix-direnv.enable = true;
      };
      programs.dircolors.enable = true;
    };
  };
}
