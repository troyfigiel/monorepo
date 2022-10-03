{ pkgs }:

pkgs.runCommand "website" {
  # TODO: Should "name" be the same everywhere?
  # TODO: Copying the script does not seem very nice, is there not a better builder I can use?
  script = builtins.path {
    path = ./.;
    name = "website";
  };

  website = builtins.path {
    path = ../../website;
    name = "website";
  };

  notes = builtins.path {
    path = ../../org/notes;
    name = "website";
  };

  blog = builtins.path {
    path = ../../org/blog;
    name = "website";
  };

  nativeBuildInputs = with pkgs; [ hugo emacs emacsPackages.ox-hugo ];
} ''
  cp -r $script/. .
  cp -r $website/. .
  chmod +w -R ./
  emacs -Q --batch -l publish.el -f 'build-all' --kill
  hugo --minify
  cp -r public $out
''
