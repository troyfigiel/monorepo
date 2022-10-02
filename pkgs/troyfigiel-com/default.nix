{ pkgs }:

pkgs.runCommand "troyfigiel-com" {
  # TODO: Should "name" be the same everywhere?
  website = builtins.path {
    path = ./.;
    name = "troyfigiel-com";
  };

  notes = builtins.path {
    path = ../../org/notes;
    name = "troyfigiel-com";
  };

  blog = builtins.path {
    path = ../../org/blog;
    name = "troyfigiel-com";
  };

  nativeBuildInputs = with pkgs; [ hugo emacs emacsPackages.ox-hugo ];
} ''
  cp -r $website/. .
  chmod +w -R ./
  emacs -Q --batch -l publish.el -f 'build-all' --kill
  hugo --minify
  cp -r public $out
''
