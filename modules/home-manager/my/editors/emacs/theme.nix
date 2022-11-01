{ pkgs, ... }:

{
  programs.emacs.init.usePackage = {
    doom-themes = {
      enable = true;
      # TODO: Does this fix things? https://github.com/hlissner/emacs-solaire-mode/issues/46
      hook =
        [ "(server-after-make-frame . (lambda () (load-theme 'doom-one t)))" ];
    };

    doom-themes-ext-treemacs = { enable = true; };

    doom-modeline = {
      enable = true;
      hook = [ "(after-init . doom-modeline-mode)" ];
      custom = { doom-modeline-vcs-max-length = "24"; };
    };

    all-the-icons = {
      enable = true;
      extraPackages = [ pkgs.emacs-all-the-icons-fonts ];
    };

    solaire-mode = {
      enable = true;
      after = [ "doom-themes" ];
      hook = [ "(after-init . solaire-global-mode)" ];
    };

    fontaine = {
      enable = true;
      hook = [
        "(server-after-make-frame . (lambda () (fontaine-set-preset 'default)))"
      ];
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
