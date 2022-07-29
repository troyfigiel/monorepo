{
  programs.bash = {
    enable = true;
    shellAliases = {
      lg = "lazygit";
      ll = "ls -alF";
      la = "ls -A";
      l = "ls -CF";
      ls = "ls --color=auto";
      grep = "grep --color=auto";
      fgrep = "fgrep --color=auto";
      egrep = "egrep --color=auto";
    };
    bashrcExtra = ''
      . ~/nixfiles/home/config/bashrc
    '';
  };
}
