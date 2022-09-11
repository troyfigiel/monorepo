{ pkgs }:

pkgs.runCommand "troyfigiel-com" {
  src = builtins.path {
    path = ./.;
    name = "troyfigiel-com";
  };
  nativeBuildInputs = [ pkgs.hugo ];
} ''
  cp -r $src/. .
  hugo --minify
  cp -r public $out
''
