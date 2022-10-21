{ inputs, lib, self, ... }:

let
  inherit (inputs.nixpkgs.lib) nixosSystem;
  inherit (self) hmModules nixosModules;
  inherit (import ./parameters.nix) cloud-server laptop virtual-devbox;
in {
  perSystem = { system, ... }: { };

  flake.nixosConfigurations = {
    "${cloud-server.machine}" = nixosSystem {
      inherit (cloud-server) system;
      specialArgs = {
        inherit inputs nixosModules;
        inherit (cloud-server) impermanence;
      };
      pkgs = self.legacyPackages.${cloud-server.system};
      modules = [
        ./cloud-server/configuration.nix
        ./cloud-server/hardware-configuration.nix
      ];
    };

    "${laptop.machine}" = nixosSystem {
      inherit (laptop) system;
      specialArgs = {
        inherit inputs nixosModules hmModules;
        inherit (laptop) impermanence;
      };
      pkgs = self.legacyPackages.${laptop.system};
      modules = [
        ./laptop/configuration.nix
        ./laptop/hardware-configuration.nix
        ./laptop/home-manager.nix
      ];
    };

    "${virtual-devbox.machine}" = nixosSystem {
      inherit (virtual-devbox) system;
      specialArgs = {
        inherit inputs nixosModules hmModules;
        inherit (virtual-devbox) impermanence;
      };
      pkgs = self.legacyPackages.${virtual-devbox.system};
      modules = [
        ./virtual-devbox/configuration.nix
        ./virtual-devbox/hardware-configuration.nix
        ./virtual-devbox/home-manager.nix
      ];
    };
  };
}
