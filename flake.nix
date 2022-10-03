{
  description = "Flake for Troy's Nixfiles";

  # We only follow nixpkgs explicitly, because pulling in different versions
  # will bloat the build process quite a bit.
  # Not following inputs might be better if you want full compatibility?
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    deploy-rs = {
      url = "github:serokell/deploy-rs";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    emacs-overlay = {
      url = "github:nix-community/emacs-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    impermanence.url = "github:nix-community/impermanence";

    nix-vscode-marketplace = {
      url = "github:AmeerTaweel/nix-vscode-marketplace";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur.url = "github:nix-community/NUR";

    simple-nixos-mailserver = {
      url = "gitlab:simple-nixos-mailserver/nixos-mailserver/nixos-22.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs:
    let
      systems = [ "x86_64-linux" ];
      inherit (inputs.nixpkgs.lib) nixosSystem genAttrs composeManyExtensions;
      inherit (inputs.home-manager.lib) homeManagerConfiguration;
    in {

      overlays.default = import ./pkgs;

      templates = import ./templates;

      legacyPackages = genAttrs systems (system:
        import inputs.nixpkgs {
          inherit system;
          config.allowUnfree = true;
          overlays = [
            inputs.self.overlays.default
            inputs.nix-vscode-marketplace.overlays.${system}.default
            inputs.emacs-overlay.overlay
          ];
        });

      # TODO: For some reason if I try to change deploy to make, it keeps on looping through the Terraform apply. Why?
      apps = genAttrs systems (system: {
        default = {
          type = "app";
          program =
            "${inputs.self.legacyPackages.${system}.deploy-rs}/bin/deploy";
        };
      });

      nixosConfigurations = {
        laptop = let system = "x86_64-linux";
        in nixosSystem {
          inherit system;
          pkgs = inputs.self.legacyPackages.${system};
          modules = [
            ./hosts/laptop
            inputs.sops-nix.nixosModules.sops
            inputs.impermanence.nixosModules.impermanence
          ];
        };

        cloud-server = let system = "x86_64-linux";
        in nixosSystem {
          inherit system;
          pkgs = inputs.self.legacyPackages.${system};
          modules = [
            ./hosts/cloud-server
            inputs.sops-nix.nixosModules.sops
            inputs.simple-nixos-mailserver.nixosModules.mailserver
          ];
        };
      };

      homeConfigurations = {
        troy = homeManagerConfiguration {
          pkgs = inputs.self.nixosConfigurations.laptop.pkgs;
          modules = let
            nur-modules = import inputs.nur {
              nurpkgs = inputs.self.legacyPackages.x86_64-linux;
              pkgs = inputs.self.legacyPackages.x86_64-linux;
            };
          in [
            ./homes/troy
            inputs.impermanence.nixosModules.home-manager.impermanence
            nur-modules.repos.rycee.hmModules.emacs-init
          ];
        };
      };

      deploy.nodes = {
        laptop = {
          hostname = "laptop";
          profilesOrder = [ "host" "troy" ];
          profiles = {
            host = {
              sshUser = "root";
              path = inputs.deploy-rs.lib.x86_64-linux.activate.nixos
                inputs.self.nixosConfigurations.laptop;
            };

            troy = {
              sshUser = "troy";
              path = inputs.deploy-rs.lib.x86_64-linux.activate.home-manager
                inputs.self.homeConfigurations.troy;
            };
          };
        };

        cloud-server = {
          hostname = "troyfigiel.com";
          profiles = {
            host = {
              sshUser = "root";
              path = inputs.deploy-rs.lib.x86_64-linux.activate.nixos
                inputs.self.nixosConfigurations.cloud-server;
            };
          };
        };
      };

      checks = builtins.mapAttrs
        (system: deployLib: deployLib.deployChecks inputs.self.deploy)
        inputs.deploy-rs.lib;
    };
}
