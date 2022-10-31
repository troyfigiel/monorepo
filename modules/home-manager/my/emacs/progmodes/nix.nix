{ pkgs, ... }:

{
  programs.emacs.init.usePackage = {
    apheleia = { extraPackages = [ pkgs.nixfmt ]; };

    lsp-mode = {
      hook = [ "(nix-mode . lsp-mode)" ];
      extraPackages = [ pkgs.rnix-lsp ];
    };

    nix-mode = {
      enable = true;
      mode = [ ''"\\.nix\\'"'' ];
    };
  };
}
