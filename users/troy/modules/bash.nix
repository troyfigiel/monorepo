{
  # TODO: What config is still in bashrc that I have not copied here?
  programs.bash = {
    enable = true;
    enableVteIntegration = true;
    shellAliases = {
      lg = "lazygit";
      ld = "lazydocker";
      ll = "ls -alF";
      la = "ls -A";
      l = "ls -CF";
      ls = "ls --color=auto";
      grep = "grep --color=auto";
      fgrep = "fgrep --color=auto";
      egrep = "egrep --color=auto";
    };
  };
}
