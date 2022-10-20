# NOTE! Directly copied from rycee.
# I am not using the hmModule through NUR because I might want to make my own adjustments in the future.
{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.programs.emacs.init;

  packageFunctionType = mkOptionType {
    name = "packageFunction";
    description = "function from epkgs to package";
    check = isFunction;
    merge = mergeOneOption;
  };

  usePackageType = types.submodule ({ name, config, ... }: {
    options = {
      enable = mkEnableOption "Emacs package ${name}";

      package = mkOption {
        type = types.either (types.str // { description = "name of package"; })
          packageFunctionType;
        default = name;
        description = ''
          The package to use for this module. Either the package name
          within the Emacs package set or a function taking the Emacs
          package set and returning a package.
        '';
      };

      defer = mkOption {
        type = types.either types.bool types.ints.positive;
        default = false;
        description = ''
          The <option>:defer</option> setting.
        '';
      };

      defines = mkOption {
        type = types.listOf types.str;
        default = [ ];
        description = ''
          The entries to use for <option>:defines</option>.
        '';
      };

      demand = mkOption {
        type = types.bool;
        default = false;
        description = ''
          The <option>:demand</option> setting.
        '';
      };

      diminish = mkOption {
        type = types.listOf types.str;
        default = [ ];
        description = ''
          The entries to use for <option>:diminish</option>.
        '';
      };

      functions = mkOption {
        type = types.listOf types.str;
        default = [ ];
        description = ''
          The entries to use for <option>:functions</option>.
        '';
      };

      mode = mkOption {
        type = types.listOf types.str;
        default = [ ];
        description = ''
          The entries to use for <option>:mode</option>.
        '';
      };

      after = mkOption {
        type = types.listOf types.str;
        default = [ ];
        description = ''
          The entries to use for <option>:after</option>.
        '';
      };

      bind = mkOption {
        type = types.attrsOf types.str;
        default = { };
        example = {
          "M-<up>" = "drag-stuff-up";
          "M-<down>" = "drag-stuff-down";
        };
        description = ''
          The entries to use for <option>:bind</option>.
        '';
      };

      command = mkOption {
        type = types.listOf types.str;
        default = [ ];
        description = ''
          The entries to use for <option>:commands</option>.
        '';
      };

      general = mkOption {
        type = types.lines;
        default = "";
        description = ''
          Code to place in the <option>:general</option> section.
        '';
      };

      # TODO: It should be relatively easy to turn the 'custom' code into an attribute set.
      custom = mkOption {
        type = types.attrs;
        default = { };
        description = ''
          Code to place in the <option>:custom</option> section.
        '';
      };

      config = mkOption {
        type = types.lines;
        default = "";
        description = ''
          Code to place in the <option>:config</option> section.
        '';
      };

      extraConfig = mkOption {
        type = types.lines;
        default = "";
        description = ''
          Additional lines to place in the use-package configuration.
        '';
      };

      hook = mkOption {
        type = types.listOf types.str;
        default = [ ];
        description = ''
          The entries to use for <option>:hook</option>.
        '';
      };

      earlyInit = mkOption {
        type = types.lines;
        default = "";
        description = ''
          Lines to add to <option>programs.emacs.init.earlyInit</option> when
          this package is enabled.
          </para><para>
          Note, the package is not automatically loaded so you will have to
          <literal>require</literal> the necessary features yourself.
        '';
      };

      init = mkOption {
        type = types.lines;
        default = "";
        description = ''
          The entries to use for <option>:init</option>.
        '';
      };

      extraPackages = mkOption {
        type = types.listOf types.package;
        default = [ ];
        description = ''
          Extra packages to add to <option>home.packages</option>.
        '';
      };

      assembly = mkOption {
        type = types.lines;
        readOnly = true;
        internal = true;
        description = "The final use-package code.";
      };
    };

    config = mkIf config.enable {
      assembly = let
        quoted = v: ''"${escape [ ''"'' ] v}"'';
        mkBindHelper = cmd: prefix: bs:
          optionals (bs != { }) ([ ":${cmd} (${prefix}" ]
            ++ mapAttrsToList (n: v: "  (${quoted n} . ${v})") bs ++ [ ")" ]);

        mkAfter = vs: optional (vs != [ ]) ":after (${toString vs})";
        mkCommand = vs: optional (vs != [ ]) ":commands (${toString vs})";
        mkDefines = vs: optional (vs != [ ]) ":defines (${toString vs})";
        mkDiminish = vs: optional (vs != [ ]) ":diminish (${toString vs})";
        mkMode = map (v: ":mode ${v}");
        mkFunctions = vs: optional (vs != [ ]) ":functions (${toString vs})";
        mkBind = mkBindHelper "bind" "";
        mkBindLocal = bs:
          let mkMap = n: v: mkBindHelper "bind" ":map ${n}" v;
          in flatten (mapAttrsToList mkMap bs);
        mkBindKeyMap = mkBindHelper "bind-keymap" "";
        mkHook = map (v: ":hook ${v}");
        mkDefer = v:
          if isBool v then
            optional v ":defer t"
          else
            [ ":defer ${toString v}" ];
        mkDemand = v: optional v ":demand t";
      in concatStringsSep "\n  " ([ "(use-package ${name}" ]
        ++ mkAfter config.after ++ mkBind config.bind ++ mkDefer config.defer
        ++ mkDefines config.defines ++ mkFunctions config.functions
        ++ mkDemand config.demand ++ mkDiminish config.diminish
        ++ mkHook config.hook ++ mkMode config.mode
        ++ optionals (config.custom != { }) ([ ":custom" ]
          ++ (mapAttrsToList (name: value: "(${name} ${value})") config.custom))
        ++ optionals (config.init != "") [ ":init" config.init ]
        ++ optionals (config.config != "") [ ":config" config.config ]
        ++ optionals (config.general != "") [ ":general" config.general ]
        ++ optional (config.extraConfig != "") config.extraConfig) + ")";
    };
  });

  usePackageStr = name: pkgConfStr: ''
    (use-package ${name}
      ${pkgConfStr})
  '';

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

  earlyInitFile = ''
    ;;; hm-early-init.el --- Emacs configuration à la Home Manager -*- lexical-binding: t; -*-
    ;;
    ;;; Commentary:
    ;;
    ;; The early init component of the Home Manager Emacs configuration.
    ;;
    ;;; Code:

    ${cfg.earlyInit}

    (provide 'hm-early-init)
    ;; hm-early-init.el ends here
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
  '' + concatStringsSep "\n\n" (map (getAttr "assembly")
    (filter (getAttr "enable") (attrValues cfg.usePackage))) + ''

      ${cfg.postlude}

      (provide 'hm-init)
      ;; hm-init.el ends here
    '';

in {
  options.programs.emacs.init = {
    enable = mkEnableOption "Emacs configuration";

    earlyInit = mkOption {
      type = types.lines;
      default = "";
      description = ''
        Configuration lines to add in <filename>early-init.el</filename>.
      '';
    };

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

    evil = {
      enable = mkEnableOption "Add evil and evil-collection integration.";
      config = mkOption {
        type = types.lines;
        default = "";
        # TODO: Write a better description
        description = ''
          Configuration lines to add ...
        '';
      };
    };

    # TODO: This does not do anything yet. I have to implement it soon.
    # The code that needs to go in the init-file is commented out.
    no-littering = {
      enable = mkEnableOption "Add no-littering integration";
      config = mkOption {
        type = types.lines;
        default = "";
        # TODO: Write a better description
        description = ''
          Configuration lines to add ...
        '';
      };
    };

    usePackage = mkOption {
      type = types.attrsOf usePackageType;
      default = { };
      example = literalExpression ''
        {
          nix-mode = {
            mode = [ '''"\\.nix\\'"''' ];
          };
        }
      '';
      description = ''
        Attribute set of use-package configurations.
      '';
    };
  };

  config = mkIf (config.programs.emacs.enable && cfg.enable) {
    # Collect the extra packages that should be included in the user profile.
    # These are typically tools called by Emacs packages.
    home.packages = concatMap (v: v.extraPackages)
      (filter (getAttr "enable") (builtins.attrValues cfg.usePackage));

    programs.emacs.init.earlyInit = let

      standardEarlyInit = mkBefore ''
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

      # Collect the early initialization strings for each package.
      packageEarlyInits = map (p: p.earlyInit)
        (filter (p: p.earlyInit != "") (builtins.attrValues cfg.usePackage));

    in mkMerge ([ standardEarlyInit ] ++ packageEarlyInits);

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
          pname = "hm-early-init";
          src = pkgs.writeText "hm-early-init.el" earlyInitFile;
          packageRequires = packages;
          preferLocalBuild = true;
          allowSubstitutes = false;
        })

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

    home.file = {
      ".emacs.d/early-init.el".text = ''
        (require 'hm-early-init)
        (provide 'early-init)
      '';

      ".emacs.d/init.el".text = ''
        (require 'hm-init)
        (provide 'init)
      '';
    };
  };
}
