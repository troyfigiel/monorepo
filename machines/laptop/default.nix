{ inputs, lib, self, ... }:

let mylib = import ../../lib/machines.nix { inherit inputs lib self; };
in mylib.mkMachineFlake {
  machine = "laptop";
  system = "x86_64-linux";
  impermanence = true;
}
