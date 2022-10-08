{ inputs, self, ... }:

let lib = import ../lib.nix { inherit inputs self; };
in lib.mkHostFlake {
  host = "laptop";
  system = "x86_64-linux";
  modules = [
    inputs.sops-nix.nixosModules.sops
    inputs.impermanence.nixosModules.impermanence
    ./networking
    ./security
    ./system
    ./configuration.nix
    ./hardware-configuration.nix
  ];
}
