{
  description = "Flake for Troy's Nixfiles";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    deploy-rs = {
      url = "github:serokell/deploy-rs";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.utils.follows = "flake-utils";
    }; 

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.utils.follows = "flake-utils";
    };

    impermanence.url = "github:nix-community/impermanence";

    nix-vscode-marketplace = {
      url = "github:AmeerTaweel/nix-vscode-marketplace";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };

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
          overlays = [
            (import ./overlay.nix)
            inputs.nix-vscode-marketplace.overlays.${system}.default
          ];
          config.allowUnfree = true;
        };

        modules = [
          ./hosts/inspiron
          inputs.sops-nix.nixosModules.sops
          inputs.impermanence.nixosModules.impermanence
          inputs.home-manager.nixosModules.home-manager
        ];
      };

      vulture = inputs.nixpkgs.lib.nixosSystem rec {
        system = "x86_64-linux";

        pkgs = import inputs.nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };

        modules = [
          ./hosts/vulture
          inputs.sops-nix.nixosModules.sops
        ];
      };
    };
  };
}
