{
  description = "Flake for Troy's Nixfiles";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-22_05.url = "github:nixos/nixpkgs/release-22.05";
    flake-utils.url = "github:numtide/flake-utils";

    deploy-rs = {
      url = "github:serokell/deploy-rs";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.utils.follows = "flake-utils";
    };

    emacs-overlay = {
      url = "github:nix-community/emacs-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
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

    nur.url = "github:nix-community/NUR";

    simple-nixos-mailserver = {
      url = "gitlab:simple-nixos-mailserver/nixos-mailserver/nixos-22.05";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nixpkgs-22_05.follows = "nixpkgs-22_05";
      inputs.utils.follows = "flake-utils";
    };

    sops-nix = {
      url = "github:mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nixpkgs-22_05.follows = "nixpkgs-22_05";
    };
  };

  outputs = inputs:
    let
      system = "x86_64-linux";
      pkgs = import inputs.nixpkgs {
        inherit system;
        overlays = [
          (import ./overlay.nix)
          inputs.nix-vscode-marketplace.overlays.${system}.default
          inputs.emacs-overlay.overlay
        ];
        config.allowUnfree = true;
      };
    in {
      nixosConfigurations = {
        ins = inputs.nixpkgs.lib.nixosSystem {
          inherit system pkgs;
          modules = [
            ./hosts/ins
            inputs.sops-nix.nixosModules.sops
            inputs.impermanence.nixosModules.impermanence
          ];
        };

        vtr = inputs.nixpkgs.lib.nixosSystem {
          inherit system pkgs;
          modules = [
            ./hosts/vtr
            inputs.sops-nix.nixosModules.sops
            inputs.simple-nixos-mailserver.nixosModules.mailserver
          ];
        };
      };

      homeConfigurations = {
        troy = inputs.home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [ ./homes/troy ];
        };
      };

      deploy.nodes = {
        ins = {
          hostname = "ins";
          profilesOrder = [ "system" "troy" ];
          profiles = {
            system = {
              user = "root";
              # TODO: This obviously is not secure, but needed to get it to work.
              sshUser = "root";
              path = inputs.deploy-rs.lib.x86_64-linux.activate.nixos
                inputs.self.nixosConfigurations.ins;
            };

            troy = {
              user = "troy";
              path = inputs.deploy-rs.lib.x86_64-linux.activate.home-manager
                inputs.self.homeConfigurations.troy;
            };
          };
        };

        vtr = {
          hostname = "troyfigiel.com";
          profiles = {
            system = {
              user = "root";
              sshUser = "root";
              path = inputs.deploy-rs.lib.x86_64-linux.activate.nixos
                inputs.self.nixosConfigurations.vtr;
            };
          };
        };
      };

      templates = import ./templates;

      checks = builtins.mapAttrs
        (system: deployLib: deployLib.deployChecks inputs.self.deploy)
        inputs.deploy-rs.lib;
    };
}
