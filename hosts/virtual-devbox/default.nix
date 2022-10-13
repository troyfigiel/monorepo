{ inputs, lib, self, ... }:

let
  inherit (lib) attrValues;
  inherit (import ../../lib/modules.nix { inherit lib; }) mapModules;
  mylib = import ../../lib/hosts.nix { inherit inputs lib self; };
  system = "aarch64-linux";
in mylib.mkHostFlake {
  inherit system;
  host = "virtual-devbox";
  impermanence = false;
  home-manager = true;
}
