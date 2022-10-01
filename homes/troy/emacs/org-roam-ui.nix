{
  programs.emacs.init.usePackage.org-roam-ui = {
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
}
