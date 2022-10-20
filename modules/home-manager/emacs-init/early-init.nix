{ config, lib, pkgs, ... }:

with lib;
let
  standardEarlyInit = ''
    (defun hm/reduce-gc ()
    "Reduce the frequency of garbage collection."
    (setq gc-cons-threshold most-positive-fixnum
            gc-cons-percentage 0.6))

    (defun hm/restore-gc ()
    "Restore the frequency of garbage collection."
    (setq gc-cons-threshold 16777216
            gc-cons-percentage 0.1))

    ;; Make GC more rare during init, while minibuffer is active, and
    ;; when shutting down. In the latter two cases we try doing the
    ;; reduction early in the hook.
    (hm/reduce-gc)
    (add-hook 'minibuffer-setup-hook #'hm/reduce-gc -50)
    (add-hook 'kill-emacs-hook #'hm/reduce-gc -50)

    ;; But make it more regular after startup and after closing minibuffer.
    (add-hook 'emacs-startup-hook #'hm/restore-gc)
    (add-hook 'minibuffer-exit-hook #'hm/restore-gc)

    ;; Avoid unnecessary regexp matching while loading .el files.
    (defvar hm/file-name-handler-alist file-name-handler-alist)
    (setq file-name-handler-alist nil)

    (defun hm/restore-file-name-handler-alist ()
    "Restores the file-name-handler-alist variable."
    (setq file-name-handler-alist hm/file-name-handler-alist)
    (makunbound 'hm/file-name-handler-alist))

    (add-hook 'emacs-startup-hook #'hm/restore-file-name-handler-alist)

    (setq package-enable-at-startup nil)

    ;; Avoid expensive frame resizing. Inspired by Doom Emacs.
    (setq frame-inhibit-implied-resize t)
  '';

  packageEarlyInits = map (p: p.earlyInit) (filter (p: p.earlyInit != "")
    (builtins.attrValues config.programs.emacs.init.usePackage));

  earlyInitFile = ''
    ;;; hm-early-init.el --- Emacs configuration à la Home Manager -*- lexical-binding: t; -*-
    ;;
    ;;; Commentary:
    ;;
    ;; The early init component of the Home Manager Emacs configuration.
    ;;
    ;;; Code:

    ${standardEarlyInit}

    ${concatStringsSep "\n" packageEarlyInits}
      
    ${config.programs.emacs.init.earlyInit}

    (provide 'hm-early-init)
    ;; hm-early-init.el ends here
  '';

in {
  options.programs.emacs.init.earlyInit = mkOption {
    type = types.lines;
    default = "";
    description = ''
      Configuration lines to add in <filename>early-init.el</filename>.
    '';
  };

  config = mkIf config.programs.emacs.enable {
    programs.emacs.extraPackages = epkgs:
      let
        getPkg = v:
          if isFunction v then
            [ (v epkgs) ]
          else
            optional (isString v && hasAttr v epkgs) epkgs.${v};

        packages = concatMap (v: getPkg (v.package)) (filter (getAttr "enable")
          (builtins.attrValues config.programs.emacs.init.usePackage));
      in [
        (epkgs.trivialBuild {
          pname = "hm-early-init";
          src = pkgs.writeText "hm-early-init.el" earlyInitFile;
          packageRequires = packages;
          preferLocalBuild = true;
          allowSubstitutes = false;
        })
      ];

    # TODO: Create an expression to find the path of hm-early-init
    home.file.".emacs.d/early-init.el".text = ''
      ;; <path to hm-early-init>
      (require 'hm-early-init)
      (provide 'early-init)
    '';
  };
}
