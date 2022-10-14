{ inputs, lib, self, ... }:

let mylib = import ../../lib/machines.nix { inherit inputs lib self; };
in mylib.mkMachineFlake {
  machine = "virtual-devbox";
  system = "aarch64-linux";
  impermanence = false;
}
