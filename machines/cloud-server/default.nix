{ inputs, lib, self, ... }:

let mylib = import ../../lib/machines.nix { inherit inputs lib self; };
in mylib.mkMachineFlake {
  machine = "cloud-server";
  system = "x86_64-linux";
  impermanence = false;
  home-manager = false;
}
