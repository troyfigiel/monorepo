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

    # TODO: For some reason I need to split this off. It has to do with autoloading somehow.
    # Is there a nicer way?
    org-remark-global-tracking = {
      enable = true;
      config = ''
        (org-remark-global-tracking-mode 1)
      '';
    };

    org-remark = {
      enable = true;
      custom = { org-remark-notes-file-name = ''".marginalia.org"''; };
      general = [''
        (:prefix "C-c"
         "km" 'org-remark-mark
         "ko" 'org-remark-open
         "kn" 'org-remark-view-next
         "kp" 'org-remark-view-prev
         "kd" 'org-remark-delete)
      ''];
    };

    # TODO: org-transclusion fails to build, because it is missing an org-transclusion-pkg.el when downloaded from ELPA.
    # This file contains metadata. Maybe this gets fixed in the future?
    # I created a ticket for it: https://github.com/nobiot/org-transclusion/issues/154
    org-transclusion = { enable = true; };

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
