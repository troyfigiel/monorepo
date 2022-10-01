{
  programs.emacs.init.usePackage = {
    hide-mode-line = {
      enable = true;
      hook = [ "(dashboard-after-initialize . hide-mode-line-mode)" ];
    };

    dashboard = {
      enable = true;
      config = ''
        (setq dashboard-startup-banner 'logo)
        (setq dashboard-center-content t)
        (setq dashboard-set-heading-icons t)
        (setq dashboard-set-file-icons t)
        ;; It is a bit strange I have to set this to a value different from projectile.
        ;; If I don't do this and try to show projects, it will pull in projectile instead
        ;; of using project.el.
        (setq dashboard-projects-backend 'project-el)
        (setq dashboard-items
         '((recents  . 10)
           (bookmarks . 5)
           (projects . 5)
           (agenda . 5)))
        (dashboard-setup-startup-hook)
      '';
    };

    beacon = {
      enable = true;
      config = ''
        (setq beacon-blink-duration 0.5)
        (beacon-mode 1)
      '';
    };

    all-the-icons-dired = {
      enable = true;
      after = [ "dired" ];
      hook = [ "(dired-mode . all-the-icons-dired-mode)" ];
    };

    zoom = {
      enable = true;
      config = ''
        (setq zoom-size '(0.618 . 0.618))
        (zoom-mode 1)
      '';
    };

    mode-icons = {
      enable = true;
      config = ''
        (setq mode-icons-show-mode-name t)
        (mode-icons-mode 1)
      '';
    };

    doom-themes = {
      enable = true;
      config = ''
        (setq doom-themes-padded-modeline t)
        (load-theme 'doom-vibrant t)
      '';
    };

    doom-modeline = {
      enable = true;
      config = ''
        (setq doom-modeline-minor-modes t)
        (doom-modeline-vcs-max-length 24)
        (doom-modeline-mode 1)
      '';
    };

    minions = {
      enable = true;
      config = "(minions-mode 1)";
    };

    dimmer = {
      enable = true;
      config = ''
        (setq dimmer-fraction 0.35)
        (dimmer-mode 1)
        (dimmer-configure-company-box)
        (dimmer-configure-magit)
        (dimmer-configure-org)
        (dimmer-configure-which-key)
        (dimmer-configure-posframe)
      '';
    };

    solaire-mode = {
      enable = true;
      hook = [ "(dashboard-after-initialize . turn-off-solaire-mode)" ];
      config = "(solaire-global-mode 1)";
    };
  };
}
