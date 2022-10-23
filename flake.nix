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

    flake-parts.url = "github:hercules-ci/flake-parts";

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

    terranix = {
      url = "github:terranix/terranix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
      inherit (self) outputs;
      inherit (inputs.flake-parts.lib) mkFlake;
    in mkFlake { inherit self; } {
      systems = [ "x86_64-linux" "aarch64-linux" ];

      imports = [
        ./packages
        ./machines
        ./virtual
        ./modules/home-manager
        ./modules/nixos
        ./modules/terranix
        ./templates/flake-module.nix
      ];

      # TODO: This is a basic working config. I will need to figure out how to leverage the perSystem functionality better.
      perSystem = { system, ... }: {
        checks = inputs.deploy-rs.lib.${system}.deployChecks inputs.self.deploy;
      };

      flake = {
        # TODO: It seems the default boot entry is not updated. That is particularly annoying and not sure why this happens.
        # Do I really need deploy-rs? Would a simple Makefile not suffice?
        deploy.nodes = {
          laptop = {
            hostname = "laptop";
            profiles = {
              system = {
                sshUser = "root";
                path = inputs.deploy-rs.lib.x86_64-linux.activate.nixos
                  inputs.self.nixosConfigurations.laptop;
              };
            };
          };

          cloud-server = {
            hostname = "troyfigiel.com";
            profiles = {
              system = {
                sshUser = "root";
                path = inputs.deploy-rs.lib.x86_64-linux.activate.nixos
                  inputs.self.nixosConfigurations.cloud-server;
              };
            };
          };
        };
      };
    };
}
