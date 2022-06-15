{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    #emacs-config.url = "gitlab:troy.figiel/emacs";
  };


  outputs = inputs@{ self, nixpkgs, home-manager }:
    let
      system = "x86_64-linux";
      username = "troy";
    in {
      homeConfigurations.${username} = home-manager.lib.homeManagerConfiguration {
        configuration = import ./home.nix;
        inherit system username;
        homeDirectory = "/home/${username}";
        stateVersion = "22.05";
      };
    };
}
