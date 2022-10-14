{ inputs, lib, self, ... }:

let mylib = import ../../lib/hosts.nix { inherit inputs lib self; };
in mylib.mkHostFlake {
  host = "virtual-devbox";
  system = "aarch64-linux";
  impermanence = false;
  home-manager = true;
}
