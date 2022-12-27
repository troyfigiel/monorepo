{ hugo, emacs, emacsPackages, runCommand }:

runCommand "website" {
  website = builtins.path {
    path = ./.;
    name = "website";
  };

  blog = builtins.path {
    path = ../blog;
    name = "blog";
  };

  nativeBuildInputs = [ hugo emacs emacsPackages.ox-hugo ];
} ''
  cp -r $website/. .
  chmod +w -R ./
  emacs -Q --batch -l publish.el -f 'build' --kill
  hugo --minify
  cp -r public $out
''
