{ impermanence, config, lib, ... }:

with lib;
let cfg = config.features.emacs;
in {
  options.features.emacs.enable = mkEnableOption "Emacs";

  config = mkIf cfg.enable (mkMerge [{
    # TODO: Do I really need this? This is slowing down my startup times?
    # services.emacs.enable = true;

    home.file.".emacs.d".source = config.lib.file.mkOutOfStoreSymlink
      "${config.xdg.userDirs.extraConfig.XDG_PROJECTS_DIR}/private/reproducible-builds/emacs";

    programs.emacs.enable = true;
  }]);
}
