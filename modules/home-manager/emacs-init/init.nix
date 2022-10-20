{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.programs.emacs.init;

  usePackageSetup = ''
    (eval-when-compile
      (require 'use-package)
      (setq use-package-verbose t))

      ;; Ensure we can use diminish
      (require 'diminish)
      (require 'general)
  '' + optionalString cfg.evil.enable ''
    (setq evil-want-integration t)
    (setq evil-want-keybinding nil)
    (require 'evil)
    (require 'evil-collection)
    (evil-collection-init)
    ${cfg.evil.config}
    (general-evil-setup t)
    (evil-mode 1)
  '' + ''
    ;; (require 'no-littering)
    ;; (setq auto-save-file-name-transforms
     ;; `((".*" ,(no-littering-expand-var-file-name "auto-save/") t)))

    ;; Fixes "Symbol’s function definition is void: use-package-autoload-keymap".
    (autoload #'use-package-autoload-keymap "use-package-bind-key")
  '';

  initFile = ''
    ;;; hm-init.el --- Emacs configuration à la Home Manager -*- lexical-binding: t; -*-
    ;;
    ;;; Commentary:
    ;;
    ;; A configuration generated from a Nix based configuration by
    ;; Home Manager.
    ;;
    ;;; Code:

    ${cfg.prelude}

    ${usePackageSetup}
  '' + concatStringsSep "\n\n" (map (getAttr "usePackageCode")
    (filter (getAttr "enable") (attrValues cfg.usePackage))) + ''

      ${cfg.postlude}

      (provide 'hm-init)
      ;; hm-init.el ends here
    '';

in {
  options.programs.emacs.init = {
    prelude = mkOption {
      type = types.lines;
      default = "";
      description = ''
        Configuration lines to add in the beginning of
        <filename>init.el</filename>.
      '';
    };

    postlude = mkOption {
      type = types.lines;
      default = "";
      description = ''
        Configuration lines to add in the end of
        <filename>init.el</filename>.
      '';
    };
  };

  config = mkIf (config.programs.emacs.enable && cfg.enable) {
    programs.emacs.extraPackages = epkgs:
      let
        getPkg = v:
          if isFunction v then
            [ (v epkgs) ]
          else
            optional (isString v && hasAttr v epkgs) epkgs.${v};

        packages = concatMap (v: getPkg (v.package))
          (filter (getAttr "enable") (builtins.attrValues cfg.usePackage));
      in [
        (epkgs.trivialBuild {
          pname = "hm-init";
          src = pkgs.writeText "hm-init.el" initFile;
          packageRequires = with epkgs;
            [ use-package diminish general ]
            ++ optional cfg.evil.enable [ epkgs.evil epkgs.evil-collection ]
            ++ optional cfg.no-littering.enable epkgs.no-littering ++ packages;
          preferLocalBuild = true;
          allowSubstitutes = false;
          preBuild = ''
            # Do a bit of basic formatting of the generated init file.
            emacs -Q --batch \
              --eval '(find-file "hm-init.el")' \
              --eval '(let ((indent-tabs-mode nil) (lisp-indent-offset 2)) (indent-region (point-min) (point-max)))' \
              --eval '(write-file "hm-init.el")'
          '';
        })
      ];

    # TODO: Create an expression to find the path of hm-init
    home.file.".emacs.d/init.el".text = ''
      ;; <path to hm-init>
      (require 'hm-init)
      (provide 'init)
    '';
  };
}

