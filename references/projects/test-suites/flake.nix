{
  description = "Reproducible Python environment using mach-nix";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    mach-nix.url = "github:davhau/mach-nix";
  };

  outputs = { flake-utils, mach-nix, ... }:
    flake-utils.lib.eachDefaultSystem (system: {
      defaultPackage = mach-nix.lib.${system}.mkPython {
        python = "python310";
        requirements = builtins.readFile ./requirements.txt;
      };
    });
}
