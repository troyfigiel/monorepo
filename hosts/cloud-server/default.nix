{ inputs, lib, self, ... }:

let mylib = import ../../lib/hosts.nix { inherit inputs lib self; };
in mylib.mkHostFlake {
  host = "cloud-server";
  system = "x86_64-linux";
  modules = [
    inputs.sops-nix.nixosModules.sops
    inputs.simple-nixos-mailserver.nixosModules.mailserver
    ./website
  ];
}
