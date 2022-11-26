{ pkgs, ... }:

{
  programs.emacs.init.usePackage = {
    doom-themes = {
      enable = true;
      config = ''
        (load-theme 'doom-one t)
      '';
    };

    # doom-themes-ext-treemacs = { enable = true; };

    doom-modeline = {
      enable = true;
      hook = [ "(after-init . doom-modeline-mode)" ];
      custom = { doom-modeline-vcs-max-length = "24"; };
    };

    all-the-icons = {
      enable = true;
      extraPackages = [ pkgs.emacs-all-the-icons-fonts ];
    };

    all-the-icons-dired = {
      enable = true;
      after = [ "all-the-icons" "dired" ];
      hook = [ "(dired-mode . all-the-icons-dired-mode)" ];
    };

    fontaine = {
      enable = true;
      config = ''
        (fontaine-set-preset 'default)
      '';
      custom = {
        fontaine-presets = ''
          '((default
             :default-family "Inconsolata"
             :default-height 140
             :line-spacing 2))
        '';
      };
      extraPackages = [ pkgs.inconsolata ];
    };
  };
}
