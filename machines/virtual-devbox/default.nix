{ inputs, lib, self, ... }:

let
  inherit (inputs.nixpkgs.lib) nixosSystem;
  machine = "virtual-devbox";
  system = "aarch64-linux";
  impermanence = false;
in {
  flake.nixosConfigurations.${machine} = nixosSystem {
    inherit system;
    specialArgs = { inherit inputs impermanence; };
    pkgs = self.legacyPackages.${system};
    modules = [
      { networking.hostName = machine; }
      ./configuration.nix
      ./hardware-configuration.nix
      ./home-manager.nix
    ];
  };
}
