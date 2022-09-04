{
  description = "Flake for Troy's Nixfiles";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    impermanence.url = "github:nix-community/impermanence";

    sops-nix = {
      url = "github:mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs: {
    nixosConfigurations = {
      inspiron = inputs.nixpkgs.lib.nixosSystem rec {
        system = "x86_64-linux";

        pkgs = import inputs.nixpkgs {
          inherit system;
          overlays = [ (import ./overlay.nix) ];
          config.allowUnfree = true;
        };

        modules = [
          ./hosts/inspiron
          inputs.sops-nix.nixosModules.sops
          inputs.impermanence.nixosModules.impermanence
          inputs.home-manager.nixosModules.home-manager
        ];
      };
    };
  };
}
