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
      # TODO: For some reason the org-level face attributes do get set, but document-title and document-info do not get set immediately.
      # I think this has to do with some part of doom-themes that sets these attributes and because I run a load theme function with the server-after-make-frame-hook, it automatically overwrites these values again.
      config = ''
        (set-face-attribute 'org-level-1 nil :height 1.3)
        (set-face-attribute 'org-level-2 nil :height 1.2)
        (set-face-attribute 'org-document-title nil :height 1.4)
        (set-face-attribute 'org-document-info nil :height 1.2)
      '';
    };

    org-indent = {
      enable = true;
      hook = [ "(org-mode . org-indent-mode)" ];
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

    # ox-hugo = { enable = true; };
  };
}
