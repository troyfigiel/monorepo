{
  description = "Flake for Troy's Nixfiles";

  inputs = {
    # hardware.url = "github:nixos/nixos-hardware";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    impermanence = {
      url = "github:nix-community/impermanence";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-colors.url = "github:misterio77/nix-colors";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nur.url = "github:nix-community/nur";
    sops-nix = {
      url = "github:mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { home-manager, impermanence, nix-colors, nixpkgs, nur, sops-nix, ... }:
    let
      system = "x86_64-linux";
    in {
      nixosConfigurations.inspiron = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit nix-colors; };
        modules = [
          ./configuration.nix
          sops-nix.nixosModules.sops
          impermanence.nixosModules.impermanence
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.troy = import ./home.nix;
          }
          # TODO: I am actually not using nur yet. Why is it in here?
          nur.nixosModules.nur
        ];
      };
    };
}
