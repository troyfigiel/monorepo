{ inputs, self, ... }:

# TODO: It would be simpler to just import all my hmModules and nixosModules here.
# All modules should be hidden behind an enable option anyway.
let
  inherit (inputs.nixpkgs.lib) nixosSystem;
  inherit (self) hmModules nixosModules;
  mkSystem = host:
    let parameters = import ./${host}/parameters.nix;
    in nixosSystem {
      inherit (parameters) system;
      specialArgs = {
        inherit inputs hmModules nixosModules;
        inherit (parameters) impermanence;
      };
      pkgs = self.legacyPackages.${parameters.system};
      modules = [ { networking.hostName = host; } ./${host} ];
    };
in {
  flake.nixosConfigurations = {
    cloud-server = mkSystem "cloud-server";
    laptop = mkSystem "laptop";
    virtual-devbox = mkSystem "virtual-devbox";
  };
}
