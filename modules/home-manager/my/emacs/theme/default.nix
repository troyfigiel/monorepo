{
  imports = [ ./dashboard.nix ./icons.nix ];

  programs.emacs.init.usePackage = {
    doom-themes = {
      enable = true;
      config = "(load-theme 'doom-vibrant t)";
    };

    doom-modeline = {
      enable = true;
      hook = [ "(after-init . doom-modeline-mode)" ];
      custom = { doom-modeline-vcs-max-length = "24"; };
    };
  };
}
