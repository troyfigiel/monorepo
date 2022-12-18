{
  description = "Your jupyterWith project";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:nixos/nixpkgs";

    poetry2nix = {
      url = "github:nix-community/poetry2nix";
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    jupyterWith = {
      url = "github:tweag/jupyterWith";
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.poetry2nix.follows = "poetry2nix";
    };
  };

  outputs = inputs:
    inputs.flake-utils.lib.eachSystem
    [ inputs.flake-utils.lib.system.x86_64-linux ] (system: rec {
      pkgs = import inputs.nixpkgs { inherit system; };

      packages.default =
        inputs.jupyterWith.lib.${system}.mkJupyterlabFromPath ./kernels {
          inherit system;
        };

      apps.default = {
        program = "${packages.default}/bin/jupyter-server";
        type = "app";
      };

      devShells.default = pkgs.mkShell { packages = [ pkgs.dvc ]; };
    });
}
