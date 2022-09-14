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
      inherit (inputs.nixpkgs.lib) nixosSystem genAttrs;
      inherit (inputs.home-manager.lib) homeManagerConfiguration;
    in {
      # TODO: What if someone wants to add sddm-sugar-candy but does not want to override vscode?
      overlays.default = import ./overlay.nix;

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

      nixosConfigurations = {
        ins = let system = "x86_64-linux";
        in nixosSystem rec {
          inherit system;
          pkgs = inputs.self.legacyPackages.${system};
          modules = [
            ./hosts/ins
            inputs.sops-nix.nixosModules.sops
            inputs.impermanence.nixosModules.impermanence
          ];
        };

        vtr = let system = "x86_64-linux";
        in nixosSystem rec {
          inherit system;
          pkgs = inputs.self.legacyPackages.${system};
          modules = [
            ./hosts/vtr
            inputs.sops-nix.nixosModules.sops
            inputs.simple-nixos-mailserver.nixosModules.mailserver
          ];
        };
      };

      homeConfigurations = {
        troy = homeManagerConfiguration {
          pkgs = inputs.self.nixosConfigurations.ins.pkgs;
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


      checks = builtins.mapAttrs
        (system: deployLib: deployLib.deployChecks inputs.self.deploy)
        inputs.deploy-rs.lib;
    };
}
