{ inputs, self, ... }:

let lib = import ../lib.nix { inherit inputs self; };
in lib.mkHostFlake {
  host = "virtual-devbox";
  system = "aarch64-linux";
  modules = [ ./configuration.nix ];
}
