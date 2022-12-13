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

  outputs = { flake-utils, jupyterWith, ... }:
    flake-utils.lib.eachSystem [ flake-utils.lib.system.x86_64-linux ] (system:
      let
        inherit (jupyterWith.lib.${system}) mkJupyterlabFromPath;
        jupyterlab = mkJupyterlabFromPath ./kernels { inherit system; };
      in {
        packages.default = jupyterlab;
        apps.default = {
          program = "${jupyterlab}/bin/jupyter-lab";
          type = "app";
        };
      });
}
