{ emacsWithPackagesFromUsePackage, emacsGit }:

emacsWithPackagesFromUsePackage {
  config = ./init.el;
  defaultInitFile = true;
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
