{ pkgs, ... }:

{
  programs.emacs.init.usePackage = {
    lsp-mode = {
      hook = [ "(terraform-mode . lsp-mode)" ];
      extraPackages = [ pkgs.terraform-ls ];
    };

    terraform-mode = { enable = true; };

    company-terraform = { enable = true; };
  };
}
