{ inputs, lib, self, ... }:

let
  inherit (inputs.nixpkgs.lib) nixosSystem;
  inherit (self) nixosModules hmModules;
  machine = "virtual-devbox";
  system = "aarch64-linux";
  impermanence = true;
in {
  flake.nixosConfigurations.${machine} = nixosSystem {
    inherit system;
    specialArgs = { inherit inputs nixosModules hmModules impermanence; };
    pkgs = self.legacyPackages.${system};
    modules = [
      { networking.hostName = machine; }
      ./configuration.nix
      ./hardware-configuration.nix
      ./home-manager.nix
    ];
  };
}
