{
  home-manager.users.troy.programs.git = {
    enable = true;
    userName = "Troy Figiel";
    userEmail = "troy.figiel@gmail.com";
    signing = { key = "E47C0DCD2768DFA138FCDCD6C67C9181B3893FB0"; };
    extraConfig = {
      init.defaultBranch = "main";
      rerere.enabled = true;
      commit.verbose = true;
      pull.rebase = true;
      push.autoSetupRemote = true;
    };
  };
}
