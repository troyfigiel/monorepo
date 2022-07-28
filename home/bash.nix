{
  programs.bash = {
    enable = true;
    shellAliases = {
      ll = "ls -alF";
      la = "ls -A";
      l = "ls -CF";
      ls = "ls --color=auto";
      grep = "grep --color=auto";
      fgrep = "fgrep --color=auto";
      egrep = "egrep --color=auto";
    };
    profileExtra = ''
      . ~/nixfiles/home/config/profile
    '';
    bashrcExtra = ''
      . ~/nixfiles/home/config/bashrc
    '';
    logoutExtra = ''
      . ~/nixfiles/home/config/bash_logout
    '';
  };
}
