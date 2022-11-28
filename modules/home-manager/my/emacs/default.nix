{ impermanence, config, lib, pkgs, ... }:

with lib;
let cfg = config.my.emacs;
in {
  imports = [ ../../emacs-init ./packages.nix ];

  options.my.emacs.enable = mkEnableOption "Emacs";

  config = mkIf cfg.enable (mkMerge [
    {
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
              (customize-set-variable 'evil-want-minibuffer t)
              (customize-set-variable 'evil-undo-system 'undo-redo)
              (customize-set-variable 'evil-disable-insert-state-bindings t)
            '';
          };

          no-littering = {
            enable = true;
            config = "\n";
          };
        };
      };

      # TODO: It works, but is not the right place for adding the package.
      # Once I move away from home-manager emacs-init, I will need to move this as well.
      home.packages = [ pkgs.tf-exif ];
    }

    (optionalAttrs impermanence {
      home.persistence."/nix/persist/${config.home.homeDirectory}".directories =
        [ ".emacs.d/eln-cache" ".emacs.d/var" ".emacs.d/etc" ];
    })
  ]);
}
