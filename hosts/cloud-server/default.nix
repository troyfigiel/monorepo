{ inputs, lib, self, ... }:

let mylib = import ../../lib/hosts.nix { inherit inputs lib self; };
in mylib.mkHostFlake {
  host = "cloud-server";
  system = "x86_64-linux";
  impermanence = false;
  modules = [
    inputs.home-manager.nixosModules.home-manager
    ./website
  ];
}
