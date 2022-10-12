{ inputs, lib, self, ... }:

let mylib = import ../../lib/hosts.nix { inherit inputs lib self; };
in mylib.mkHostFlake {
  host = "cloud-server";
  system = "x86_64-linux";
  impermanence = false;
  modules = [
    inputs.sops-nix.nixosModules.sops
    inputs.impermanence.nixosModules.impermanence
    inputs.home-manager.nixosModules.home-manager
    inputs.simple-nixos-mailserver.nixosModules.mailserver
    ./website
  ];
}
