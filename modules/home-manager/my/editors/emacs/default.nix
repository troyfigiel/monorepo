{ impermanence, config, lib, ... }:

with lib;
let cfg = config.my.emacs;
in {
  imports = [ ../../../emacs-init ./packages.nix ];

  options.my.emacs.enable = mkEnableOption "Emacs";

  config = mkIf cfg.enable (mkMerge [
    {
      services.emacs = {
        enable = true;
        startWithUserSession = true;
        defaultEditor = true;
      };

      # We do not need to set emacsNativeComp, because the default emacs package is already natively compiled.
      programs.emacs = {
        enable = true;
        init = {
          enable = true;
          earlyInit = ''
            (scroll-bar-mode -1)
            (tool-bar-mode -1)
            (tooltip-mode -1)
            (set-fringe-mode 10)
            (menu-bar-mode -1)
          '';

          prelude = ''
            (add-to-list 'default-frame-alist '(alpha 90 . 90))
            (setq custom-file null-device)
            (setq sentence-end-double-space nil)
            (setq visible-bell t)
            (column-number-mode 1)
            (setq initial-scratch-message "")
          '';

          evil = {
            enable = true;
            config = ''
              ;; evil seems to require customize for all its variables
              (customize-set-variable 'evil-want-C-u-scroll t)
              (customize-set-variable 'evil-undo-system 'undo-redo)
            '';
          };

          no-littering = {
            enable = true;
            config = "\n";
          };
        };
      };
    }

    (optionalAttrs impermanence {
      home.persistence."/nix/persist/${config.home.homeDirectory}".directories =
        [ ".emacs.d/eln-cache" ".emacs.d/var" ".emacs.d/etc" ];
    })
  ]);
}
