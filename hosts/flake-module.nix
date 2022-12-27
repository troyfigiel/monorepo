{ inputs, self, ... }:

let
  inherit (inputs.nixpkgs.lib) nameValuePair nixosSystem;
  mkSystem = { host, system, impermanence }:
    nixosSystem {
      inherit system;
      specialArgs = {
        inherit inputs self impermanence;
        inherit (self) hmModules nixosModules;
      };
      pkgs = self.legacyPackages.${system};
      modules = [ { networking.hostName = host; } ./${host} ];
    };
in {
  flake.nixosConfigurations = builtins.listToAttrs
    (map (hostAttrs: nameValuePair hostAttrs.host (mkSystem hostAttrs)) [
      {
        host = "laptop";
        system = "x86_64-linux";
        impermanence = true;
      }
      {
        host = "cloud-server";
        system = "x86_64-linux";
        impermanence = false;
      }
      {
        host = "virtual-devbox";
        system = "aarch64-linux";
        impermanence = true;
      }
    ]);

  # TODO: This is a basic working config. I will need to figure out how to leverage the perSystem functionality better.
  perSystem = { pkgs, ... }: {
    apps.hosts = {
      type = "app";
      program = pkgs.callPackage ./deploy.nix { };
    };
  };
}
