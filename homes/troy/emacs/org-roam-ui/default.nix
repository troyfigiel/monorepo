{
  programs.emacs.init.usePackage.org-roam-ui = {
    enable = true;
    after = [ "org-roam" ];
    diminish = [ "org-roam-ui-mode" ];
    hook = [ "(after-init . org-roam-ui-mode)" ];
    config = builtins.readFile ./config.el;
  };
}
