{ pkgs, ... }:

{
  imports = [ ./org ./csv.nix ./git.nix ./latex.nix ./yaml.nix ];

  programs.emacs.init.usePackage = {
    flyspell = {
      enable = true;
      hook = [ "(text-mode . flyspell-mode)" ];
      extraPackages = [ pkgs.ispell ];
    };

    whitespace-cleanup-mode = {
      enable = true;
      hook = [ "(text-mode . whitespace-cleanup-mode)" ];
    };

    # Olivetti did not work out. There was too much interference with other packages:
    # - The blue indicator used by treemacs disappeared with olivetti.
    # - The fringe indicator for git changes was stretched out across the entire fringe (quarter of the screen).
    visual-fill-column = {
      enable = true;
      hook = [
        "(org-mode . visual-line-mode)"
        "(markdown-mode . visual-line-mode)"
        "(visual-line-mode . visual-fill-column-mode)"
      ];
      custom = {
        visual-fill-column-center-text = "t";
        visual-fill-column-width = "99";
      };
    };

    toc-org = {
      enable = true;
      hook = [ "(org-mode . toc-org-mode)" "(markdown-mode . toc-org-mode)" ];
    };
  };
}
