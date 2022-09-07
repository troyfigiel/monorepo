{ pkgs, ... }:

{
  # TODO: Use the includeModule options to create different git configs
  # for Projects/Private and Projects/Work.
  programs.git = {
    enable = true;
    userName = "Troy Figiel";
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

  programs.lazygit = {
    enable = true;
    settings = { disableStartupPopups = true; };
  };

  systemd.user.services = {
    clone-emacs-config = {
      Unit = {
        Description = "Service that clones my Emacs config to .emacs.d";
      };

      Service = {
        Type = "oneshot";
        ExecStart =
          "${pkgs.git}/bin/git clone git@gitlab.com:troy.figiel/emacs.git /home/troy/.emacs.d";
      };
    };

    clone-notes = {
      Unit = { Description = "Service that clones my Zettelkasten notes"; };

      Service = {
        Type = "oneshot";
        ExecStart =
          "${pkgs.git}/bin/git clone git@gitlab.com:troy.figiel/zettelkasten.git /home/troy/zettelkasten";
      };
    };
  };
}
