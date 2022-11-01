{
  programs.emacs.init.usePackage = {
    # TODO: If I run treemacs-rename I run into a missing crfs-read function.
    # Which package contains this function?
    treemacs = {
      enable = true;
      general = [ ''("<f7>" 'treemacs)'' ];
    };
    treemacs-evil = { enable = true; };
    treemacs-file-management = { enable = true; };
    treemacs-magit = { enable = true; };

    hide-mode-line = {
      enable = true;
      hook = [ "(treemacs-mode . hide-mode-line-mode)" ];
    };
  };
}
