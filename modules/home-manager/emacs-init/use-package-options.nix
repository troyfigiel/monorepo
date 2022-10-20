{ name, config, lib, ... }:

with lib; {
  options = {
    enable = mkEnableOption "Emacs package ${name}";

    package = mkOption {
      type = types.str;
      default = name;
      description = ''
        The package to use for this module. The package name
        within the Emacs package set.
      '';
    };

    defer = mkOption {
      type = types.bool;
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
      type = types.listOf types.str;
      default = [ ];
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

    usePackageCode = mkOption {
      type = types.lines;
      readOnly = true;
      internal = true;
      description = "The final use-package code.";
    };
  };

  config = mkIf config.enable {
    usePackageCode = let
      mkAfter = vs: optional (vs != [ ]) ":after (${toString vs})";
      mkCommand = vs: optional (vs != [ ]) ":commands (${toString vs})";
      mkDefines = vs: optional (vs != [ ]) ":defines (${toString vs})";
      mkDiminish = vs: optional (vs != [ ]) ":diminish (${toString vs})";
      mkMode = map (v: ":mode ${v}");
      mkFunctions = vs: optional (vs != [ ]) ":functions (${toString vs})";
      # TODO: General can have the following keywords: prefix, states, keymaps. This is then followed by the keybindings and the function they map to.
      # For example:
      # general = [{ states = [ "normal" ]; keymaps = [ "x-keymap" ]; prefix = "SPC"; bindings = { function1 = "a"; function2 = "b"; };}]
      mkGeneral = vs: optional (vs != [ ]) ":general ${toString vs}";
      # TODO: Nicer would be { mode = "x-mode"; after = "y-mode"; } instead of "( y-mode . x-mode )" or something of this form.
      mkHook = map (v: ":hook ${v}");
      mkDefer = v: optional v ":defer t";
      mkDemand = v: optional v ":demand t";
    in concatStringsSep "\n  " ([ "(use-package ${name}" ]
      ++ mkAfter config.after ++ mkDefer config.defer
      ++ mkDefines config.defines ++ mkFunctions config.functions
      ++ mkDemand config.demand ++ mkDiminish config.diminish
      ++ mkHook config.hook ++ mkMode config.mode ++ mkGeneral config.general
      ++ optionals (config.custom != { }) ([ ":custom" ]
        ++ (mapAttrsToList (name: value: "(${name} ${value})") config.custom))
      ++ optionals (config.init != "") [ ":init" config.init ]
      ++ optionals (config.config != "") [ ":config" config.config ]
      ++ optional (config.extraConfig != "") config.extraConfig) + ")";
  };
}
