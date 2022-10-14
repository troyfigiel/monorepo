{ config, lib, ... }:

with lib;
let cfg = config.roles.git;
in {
  options.roles.git = {
    enable = mkEnableOption "git";
    # userEmail = mkOption {
    #   type = types.nullOr types.string;
    #   description = ''
    #     User email to set for git.
    #   '';
    # };

    # lazygit.enable = mkEnableOption "lazygit";
  };

  # TODO: Use the includeModule options to create different git configs
  # for Projects/Private and Projects/Work.
  config = mkIf cfg.enable {
    programs.git = {
      enable = true;
      userName = "Troy Figiel";
      # userEmail = cfg.userEmail;
      userEmail = "troy.figiel@gmail.com";
      # signing = {
      #   key = "E47C0DCD2768DFA138FCDCD6C67C9181B3893FB0";
      #   signByDefault = true;
      # };
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

    programs.lazygit = { # mkIf cfg.lazygit.enable {
      enable = true;
      settings = { disableStartupPopups = true; };
    };
  };
}
