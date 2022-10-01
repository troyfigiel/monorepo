let
  orgRoamDirectory = "/home/troy/projects/private/nixos-config/org/notes";
in {
  programs.emacs.init.usePackage = {
    org-roam = {
      enable = true;
      after = [ "org" ];
      config = ''
        (setq org-roam-directory "${orgRoamDirectory}")
        (org-roam-db-autosync-enable)
        ;; TODO: This will not work as is, because there are no org templates in my repo yet.
        ;; (band-aid-org-roam-set-templates
        ;; (expand-file-name "org/templates" user-emacs-directory))
      '';
    };

    org-roam-ui = {
      enable = true;
      after = [ "org-roam" ];
      diminish = [ "org-roam-ui-mode" ];
      hook = [ "(after-init . org-roam-ui-mode)" ];
      config = ''
        (setq org-roam-ui-sync-theme t)
        (setq org-roam-ui-follow t)
        (setq org-roam-ui-update-on-save t)
        (setq org-roam-ui-open-on-start nil)
      '';
    };

    org-roam-timestamps = {
      enable = true;
      after = [ "org-roam" ];
      diminish = [ "org-roam-timestamps-mode" ];
      config = "(setq org-roam-timestamps-remember-timestamps nil)";
    };

    deft = {
      enable = true;
      after = [ "org-roam" ];
      config = ''
        (setq deft-recursive t)
        (setq deft-use-filter-string-for-filename t)
        (setq deft-default-extension "org")
        (setq deft-directory org-roam-directory)
      '';
    };
  };
}
