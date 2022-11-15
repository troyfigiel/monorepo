{ config, lib, ... }:

with lib;
let cfg = config.my.git;
in {
  options.my.git = { enable = mkEnableOption "git"; };

  config = mkIf cfg.enable {
    programs.git = {
      enable = true;
      userName = "Troy Figiel";
      userEmail = "troy.figiel@gmail.com";
      signing = { key = "E47C0DCD2768DFA138FCDCD6C67C9181B3893FB0"; };
      extraConfig = {
        init.defaultBranch = "main";
        rerere.enabled = true;
        commit.verbose = true;
        color.ui = "auto";
        core.editor = "vim";
        merge.conflictstyle = "diff3";
        pull.rebase = true;
        push.autoSetupRemote = true;
      };
    };

    # TODO: I should start using Emacs for this once I get the terminal colours for Magit to work nicely.
    programs.lazygit = {
      enable = true;
      settings = { disableStartupPopups = true; };
    };
  };
}
