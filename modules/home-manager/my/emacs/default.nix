{ impermanence, config, lib, ... }:

with lib;
let cfg = config.my.emacs;
in {
  imports = [ ../../emacs-init ./packages.nix ];

  options.my.emacs.enable = mkEnableOption "Emacs";

  config = mkIf cfg.enable (mkMerge [
    {
      # TODO: Do I really need this? This is slowing down my startup times?
      # services.emacs.enable = true;

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
            (defvar tf/default-font-size 120)
            (defvar tf/default-variable-font-size 120)

            (set-face-attribute 'default nil :height tf/default-font-size)

            ;; Set the fixed pitch face
            (set-face-attribute 'fixed-pitch nil :height tf/default-font-size)

            ;; Set the variable pitch face
            (set-face-attribute 'variable-pitch nil :height tf/default-variable-font-size :weight 'regular)

            (defvar tf/frame-transparency '(100 . 100))

            (set-frame-parameter (selected-frame) 'alpha tf/frame-transparency)
            (add-to-list 'default-frame-alist `(alpha . ,tf/frame-transparency))

            (set-frame-parameter (selected-frame) 'fullscreen 'maximized)
            (add-to-list 'default-frame-alist '(fullscreen . maximized))

            (setq mode-line-percent-position nil)

            ;; No custom file. Complete reproducibility.
            (setq custom-file null-device)

            ;; By default emacs requires two spaces after a period to end a sentence. This is an old default that interferes with evil.
            (setq sentence-end-double-space nil)

            ;; Without the visible bell, hitting the edges of a file will make an annoying noise.
            ;; TODOC: Is this really the case?
            (setq visible-bell t)
            (column-number-mode 1)
          '';

          evil = {
            enable = true;
            config = ''
              (setq evil-want-C-u-scroll t)
              (setq evil-want-C-i-jump nil)
              (setq evil-undo-system 'undo-tree)
              (setq evil-mode-line-format nil)
            '';
          };

          no-littering = {
            enable = true;
            config = "\n";
          };
        };
      };

      home.sessionVariables = {
        ORG_DIRECTORY = "/home/troy/projects/private/nix-builds/org/";
      };
    }

    (optionalAttrs impermanence {
      home.persistence."/nix/persist/${config.home.homeDirectory}".directories =
        [ ".emacs.d/eln-cache" ".emacs.d/var" ".emacs.d/etc" ];
    })
  ]);
}
