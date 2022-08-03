{
  programs.git = {
    enable = true;
    userName = "Troy Figiel";
    userEmail = "troy.figiel@gmail.com";
    signing = {
      key = "E47C0DCD2768DFA138FCDCD6C67C9181B3893FB0";
      signByDefault = true;
    };
    extraConfig = {
      init.defaultBranch = "main";
      rerere.enabled = true;
      commit.verbose = true;
      color.ui = "auto";
      core.editor = "vim";
      merge.conflictstyle = "diff3";
      pull.rebase = true;
    };
  };

  programs.lazygit ={
    enable = true;
    settings = {
      disableStartupPopups = true;
    };
  };
}
