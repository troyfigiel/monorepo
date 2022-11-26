{ pkgs, ... }:

{
  programs.emacs.init.usePackage = {
    eglot = {
      hook = [ "(sql-mode . eglot-ensure)" ];
      extraPackages = [ pkgs.sqls ];
    };
  };
}
