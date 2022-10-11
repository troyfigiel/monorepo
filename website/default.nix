{ pkgs }:

pkgs.runCommand "website" {
  website = builtins.path {
    path = ./.;
    name = "website";
  };

  notes = builtins.path {
    path = ../org/notes;
    name = "website";
  };

  blog = builtins.path {
    path = ../org/blog;
    name = "website";
  };

  nativeBuildInputs = with pkgs; [ hugo emacs emacsPackages.ox-hugo ];
} ''
  cp -r $website/. .
  chmod +w -R ./
  emacs -Q --batch -l publish.el -f 'build-all' --kill
  hugo --minify
  cp -r public $out
''