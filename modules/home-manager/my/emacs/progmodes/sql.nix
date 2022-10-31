{ pkgs, ... }:

{
  programs.emacs.init.usePackage = {
    lsp-mode = {
      hook = [ "(sql-mode . lsp-mode)" ];
      extraPackages = [ pkgs.sqls ];
    };
  };
}
