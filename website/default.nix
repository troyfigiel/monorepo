{ hugo, emacs, emacsPackages, runCommand }:

runCommand "website" {
  website = builtins.path {
    path = ./.;
    name = "website";
  };

  references = builtins.path {
    path = ../references;
    name = "references";
  };

  nativeBuildInputs = [ hugo emacs emacsPackages.ox-hugo ];
} ''
  cp -r $website/. .
  chmod +w -R ./
  emacs -Q --batch -l publish.el -f 'build-all' --kill
  hugo --minify
  cp -r public $out
''
