{
  programs.emacs.init.usePackage = {
    treemacs = {
      enable = true;
      general = [ ''("<f7>" 'treemacs)'' ];
    };
    treemacs-evil = { enable = true; };
    treemacs-file-management = { enable = true; };
    treemacs-magit = { enable = true; };
    # treemacs-projectile = { enable = true; };

    hide-mode-line = {
      enable = true;
      hook = [ "(treemacs-mode . hide-mode-line-mode)" ];
    };
  };
}
