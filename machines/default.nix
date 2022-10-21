{ inputs, self, ... }:

let
  inherit (builtins) listToAttrs;
  inherit (import ./lib.nix { inherit inputs self; }) createNixosSystem;
in {
  flake.nixosConfigurations = listToAttrs
    (map createNixosSystem [ "cloud-server" "laptop" "virtual-devbox" ]);
}

