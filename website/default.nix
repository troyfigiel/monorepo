{ hugo, emacs, emacsPackages, runCommand }:

runCommand "website" {
  website = builtins.path {
    path = ./.;
    name = "website";
  };

  org = builtins.path {
    path = ../org;
    name = "org";
  };

  nativeBuildInputs = [ hugo emacs emacsPackages.ox-hugo ];
} ''
  cp -r $website/. .
  chmod +w -R ./
  emacs -Q --batch -l publish.el -f 'build-all' --kill
  hugo --minify
  cp -r public $out
''
