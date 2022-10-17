{ impermanence, config, lib, ... }:

with lib;
let cfg = config.features.nvim;
in {
  options.features.nvim = {
    enable = mkEnableOption "nvim";
    defaultEditor = mkOption {
      default = true;
      type = types.bool;
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      programs.neovim = {
        enable = true;
        viAlias = true;
        vimAlias = true;
      };
    }
    (mkIf cfg.defaultEditor { home.sessionVariables.EDITOR = "vi"; })
  ]);
}
