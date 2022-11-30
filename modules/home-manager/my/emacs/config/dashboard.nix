{
  programs.emacs.init.usePackage = {
    dashboard = {
      enable = true;
      custom = {
        dashboard-banner-logo-title = "nil";
        dashboard-bookmarks-show-base = "nil";
        dashboard-center-content = "t";
        dashboard-footer = ''""'';
        dashboard-projects-backend = "'project-el";
        dashboard-set-file-icons = "nil";
        dashboard-set-heading-icons = "t";
        dashboard-set-init-info = "nil";
        dashboard-startup-banner = "nil";
        dashboard-footer-icon = "nil";
        dashboard-footer-messages = "nil";
        dashboard-items = ''
          '((bookmarks . 10)
            (projects . 10))
        '';
      };
      config = ''
        (dashboard-setup-startup-hook)
      '';
    };
  };
}
