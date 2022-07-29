{
  programs.git = {
    enable = true;
    userName = "Troy Figiel";
    userEmail = "troy.figiel@gmail.com";
    extraConfig = {
      init = { defaultBranch = "main"; };
      rerere = { enabled = true; };
      commit = { verbose = true; };
      color = { ui = "auto"; };
      core = { editor = "vim"; };
      merge = { conflictstyle = "diff3"; };
    };
  };

  programs.lazygit ={
    enable = true;
    settings = {
      disableStartupPopups = true;
    };
  };
}
