{
  description = "Flake for @package@";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:NixOS/nixpkgs";
    devshell = {
      url = "github:numtide/devshell";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
    poetry2nix = {
      url = "github:nix-community/poetry2nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
  };

  outputs = inputs:
    (inputs.flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import inputs.nixpkgs {
          inherit system;
          overlays = [ inputs.devshell.overlay inputs.poetry2nix.overlay ];
        };

        package-name = "@package@";
        python = pkgs.python310;
        poetry = pkgs.poetry.override { inherit python; };

        venv = pkgs.poetry2nix.mkPoetryEnv {
          inherit python;
          projectDir = ./.;
        };
      in {
        devShell = pkgs.devshell.mkShell {
          name = "${package-name}-dev-shell";
          packages = [ venv ];
          commands = [{
            name = "poetry";
            package = poetry;
          }];
        };
      }));
}
