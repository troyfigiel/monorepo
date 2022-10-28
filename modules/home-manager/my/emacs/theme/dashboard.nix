{
  programs.emacs.init.usePackage = {
    hide-mode-line = {
      enable = true;
      hook = [ "(dashboard-after-initialize . hide-mode-line-mode)" ];
    };

    dashboard = {
      enable = true;
      custom = {
        dashboard-startup-banner = "'logo";
        dashboard-center-content = "t";
        dashboard-set-heading-icons = "t";
        dashboard-set-file-icons = "t";
        dashboard-projects-backend = "'project-el";
        dashboard-items = ''
          '((recents  . 10)
            (bookmarks . 5)
            (projects . 5)
            (agenda . 5))
        '';
      };
      config = "(dashboard-setup-startup-hook)";
    };
  };
}
