{ pkgs, ... }:

{
  programs.emacs.init.usePackage = {
    apheleia = { extraPackages = [ pkgs.nixfmt ]; };

    eglot = {
      hook = [ "(nix-mode . eglot-ensure)" ];
      extraPackages = [ pkgs.rnix-lsp ];
    };

    nix-mode = {
      enable = true;
      mode = [ ''"\\.nix\\'"'' ];
    };
  };
}
