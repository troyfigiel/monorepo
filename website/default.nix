{ hugo, emacs, emacsPackages, runCommand }:

runCommand "website" {
  website = builtins.path {
    path = ./.;
    name = "website";
  };

  notes = builtins.path {
    path = ../emacs.d/org/notes;
    name = "website";
  };

  blog = builtins.path {
    path = ../emacs.d/org/blog;
    name = "website";
  };

  nativeBuildInputs = [ hugo emacs emacsPackages.ox-hugo ];
} ''
  cp -r $website/. .
  chmod +w -R ./
  emacs -Q --batch -l publish.el -f 'build-all' --kill
  hugo --minify
  cp -r public $out
''
