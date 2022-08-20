{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./networking
    ./security
    ./system
    ./users
  ];

  nix = {
    package = pkgs.nixFlakes;
    settings.auto-optimise-store = true;

    gc = {
      automatic = true;
      dates = "weekly";
    };

    extraOptions =
      pkgs.lib.optionalString (config.nix.package == pkgs.nixFlakes)
      "experimental-features = nix-command flakes";

    # TODO: Should I add an automatic garbage collection when I do not have enough space?
    # How much space should I free?
    # nix.extraOptions = ''
    #   min-free = ${toString (100 * 1024 * 1024)}
    #   max-free = ${toString (1024 * 1024 * 1024)}
    # '';
  };

  nixpkgs.config = { allowUnfree = true; };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    # users.root = ./root;
    users.troy = ./users/troy;
  };

}
