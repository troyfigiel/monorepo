{ inputs, self }:

# TODO: Do we really need the mkHostFlake? It is now a tiny wrapper around nixosConfigurations
{
  mkHostFlake = { host, system, modules }:
    let inherit (inputs.nixpkgs.lib) nixosSystem;
    in {
      flake.nixosConfigurations.${host} = nixosSystem {
        inherit system modules;
        pkgs = self.legacyPackages.${system};
      };
    };
}
