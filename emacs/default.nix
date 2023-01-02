{ dtach, emacsWithPackagesFromUsePackage, emacsGit, exiftool, git, imagemagick
, jupytext, notmuch, ripgrep, rsync, substituteAll }:

emacsWithPackagesFromUsePackage {
  config = ./init.el;
  defaultInitFile = substituteAll {
    name = "default.el";
    src = ./init.el;
    inherit dtach exiftool git imagemagick jupytext notmuch ripgrep rsync;
  };
  package = emacsGit;
  alwaysEnsure = false;
  override = epkgs:
    epkgs // {
      tf-lisp = epkgs.trivialBuild {
        pname = "tf-lisp";
        src = builtins.path {
          path = ./tf-lisp;
          name = "lisp";
        };
        packageRequires = [ epkgs.denote ];
      };
    };
}
