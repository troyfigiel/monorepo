{
  flake = {
    hmFeatures = import ./home-manager;
    nixosFeatures = import ./nixos;
    terranixFeatures = import ./terranix;
  };
}
