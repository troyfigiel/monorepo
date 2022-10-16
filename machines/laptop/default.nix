{ inputs, lib, self, ... }:

let
  inherit (inputs.nixpkgs.lib) nixosSystem;
  machine = "laptop";
  system = "x86_64-linux";
  impermanence = true;
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
