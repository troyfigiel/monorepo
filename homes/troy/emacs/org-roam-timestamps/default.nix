{
  programs.emacs.init.usePackage.org-roam-timestamps = {
    enable = true;
    after = [ "org-roam" ];
    diminish = [ "org-roam-timestamps-mode" ];
    config = "(setq org-roam-timestamps-remember-timestamps nil)";
  };
}
