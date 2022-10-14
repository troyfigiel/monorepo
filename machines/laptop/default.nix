{ inputs, lib, self, ... }:

let
  inherit (import ../../lib/machines.nix { inherit inputs lib self; })
    mkMachineFlake;
in mkMachineFlake {
  machine = "laptop";
  system = "x86_64-linux";
  impermanence = true;
}
