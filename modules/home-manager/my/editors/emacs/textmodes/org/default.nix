{
  imports = [ ./org-babel.nix ./org-cdlatex.nix ./org-roam.nix ];

  programs.emacs.init.usePackage = {
    org = {
      enable = true;
      custom = {
        org-catch-invisible-edits = "'show-and-error";
        org-ellipsis = ''" …"'';
        org-pretty-entities = "t";
        org-hide-emphasis-markers = "t";
        org-startup-with-latex-preview = "t";
      };
      config = ''
        (set-face-attribute 'org-level-1 nil :height 1.2)
        (set-face-attribute 'org-level-2 nil :height 1.1)
        (set-face-attribute 'org-document-title nil :height 1.5)
        (set-face-attribute 'org-document-info nil :height 1.1)
      '';
    };

    org-modern = {
      enable = true;
      hook = [ "(after-init . global-org-modern-mode)" ];
    };

    # TODO: Does this interfere with org-modern?
    # TODO: Find out how well this works compared to the default.
    # (use-package valign
    #   :custom (valign-fancy-bar t)
    #   :hook (org-mode . valign-mode))

    toc-org = { hook = [ "(org-mode . toc-org-mode)" ]; };

    # TODO: This does not work together well with `diff-hl', because it ends
    # up creating a very large coloured block instead of a small fringe whenever
    # I changed, add or delete something to a git controlled file.
    # TODO: Can I add `olivetti' and have it work together well with `visual-fill-column'
    # or is it a replacement of that package?

    # org-appear = {
    #   enable = true;
    #   hook = [ "(org-mode . org-appear-mode)" ];
    # };

    # ox-hugo = { enable = true; };

    olivetti = { hook = [ "(org-mode . olivetti-mode)" ]; };
  };
}
