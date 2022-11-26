{
  programs.emacs.init.usePackage = {
    dashboard = {
      enable = true;
      custom = {
        dashboard-banner-logo-title = "nil";
        dashboard-center-content = "t";
        dashboard-footer = ''""'';
        dashboard-projects-backend = "'project-el";
        dashboard-set-file-icons = "t";
        dashboard-set-init-info = "nil";
        dashboard-startup-banner = "nil";
        dashboard-footer-icon = "nil";
        dashboard-footer-messages = "nil";
        dashboard-items = ''
          '((recents . 10)
            (bookmarks . 10)
            (projects . 10))
        '';
      };
      config = ''
        (dashboard-setup-startup-hook)
      '';
    };
  };
}
