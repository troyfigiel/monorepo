{
  flake = {
    nixosModules = import ./nixos;
    hmModules = import ./home-manager;
    terranixModules = import ./terranix;
  };
}
