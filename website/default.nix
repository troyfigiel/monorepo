{ pkgs }:

let
  src = ./src;
  minimalist = pkgs.fetchFromGitHub {
    owner = "ronv";
    repo = "minimalist";
    rev = "053e1904b65e3c98d356516c9aeaa696270003ba";
    sha256 = "sha256-6m+RRJUWwD8a0O3gDnvflOp7sFHho+9WJPQOMt8T2zE=";
  };
in pkgs.stdenv.mkDerivation {
  inherit src;
  name = "website";

  unpackPhase = ''
    cp -r $src/. .
    mkdir -p themes
    cp -r ${minimalist} themes/minimalist
  '';

  buildPhase = ''
    ${pkgs.hugo}/bin/hugo --minify
  '';

  installPhase = ''
    mkdir -p $out
    cp -r public $out/public
  '';
}
