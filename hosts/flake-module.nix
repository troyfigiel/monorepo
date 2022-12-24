{ inputs, self, ... }:

let
  inherit (inputs.nixpkgs.lib)
    filterAttrs mapAttrsToList nameValuePair nixosSystem;
  inherit (builtins) listToAttrs readDir;
  inherit (self) hmModules nixosModules;

  hostNamesToList = mapAttrsToList (name: _: name)
    (filterAttrs (_: value: value == "directory") (readDir ./.));

  mkSystem = host:
    let parameters = import ./${host}/parameters.nix;
    in nixosSystem {
      inherit (parameters) system;
      specialArgs = {
        inherit inputs self hmModules nixosModules;
        inherit (parameters) impermanence;
      };
      pkgs = self.legacyPackages.${parameters.system};
      modules = [ { networking.hostName = host; } ./${host} ];
    };
in {
  flake.nixosConfigurations = listToAttrs
    (map (host: nameValuePair host (mkSystem host)) hostNamesToList);

  # TODO: This is a basic working config. I will need to figure out how to leverage the perSystem functionality better.
  perSystem = { pkgs, ... }: {
    apps.hosts = {
      type = "app";
      program = pkgs.callPackage ./deploy.nix { };
    };
  };
}
