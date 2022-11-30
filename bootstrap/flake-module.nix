{
  perSystem = { pkgs, ... }: {
    apps.bootstrap = {
      type = "app";
      program = pkgs.callPackage ./bootstrap.nix { };
    };
  };
}
