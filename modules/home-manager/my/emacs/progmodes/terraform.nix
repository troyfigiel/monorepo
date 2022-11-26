{ pkgs, ... }:

{
  programs.emacs.init.usePackage = {
    eglot = {
      hook = [ "(terraform-mode . eglot-ensure)" ];
      extraPackages = [ pkgs.terraform-ls ];
    };

    terraform-mode = { enable = true; };

    company-terraform = { enable = true; };
  };
}
