{ inputs, self, ... }:

let lib = import ../lib.nix { inherit inputs self; };
in lib.mkHostFlake {
  host = "cloud-server";
  system = "x86_64-linux";
  modules = [
    inputs.sops-nix.nixosModules.sops
    inputs.simple-nixos-mailserver.nixosModules.mailserver
    ./configuration.nix
    ./hardware-configuration.nix
    ./sops.nix
    ./sshd.nix
    ./users.nix
    ./website
  ];
}
