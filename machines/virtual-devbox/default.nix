{ inputs, lib, self, ... }:

let
  inherit (import ../../lib/machines.nix { inherit inputs lib self; })
    mkMachineFlake;
in mkMachineFlake {
  machine = "virtual-devbox";
  system = "aarch64-linux";
  impermanence = false;
}
