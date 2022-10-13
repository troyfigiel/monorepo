{ inputs, lib, self, ... }:

let
  inherit (lib) attrValues;
  inherit (import ../../lib/modules.nix { inherit lib; }) mapModules;
  mylib = import ../../lib/hosts.nix { inherit inputs lib self; };
  system = "x86_64-linux";
in mylib.mkHostFlake {
  inherit system;
  impermanence = true;
  host = "laptop";
  home-manager = true;
  modules = [ ./system ./networking.nix ./security.nix ];
}
