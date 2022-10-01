{
  programs.emacs.init.usePackage.deft = {
    enable = true;
    after = [ "org-roam" ];
    config = ''
      (setq deft-recursive t)
      (setq deft-use-filter-string-for-filename t)
      (setq deft-default-extension "org")
      (setq deft-directory org-roam-directory)
    '';
  };
}
