{ inputs }:

{
  mkHost = { hostname, system, pkgs, extraModules }:
    inputs.nixpkgs.lib.nixosSystem {
      inherit system pkgs;
      modules = [ ../hosts/${hostname} ] ++ extraModules;
    };

  mkHome = { homename, pkgs }:
    inputs.home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      modules = [ ../homes/${homename} ];
    };
}
