{
  programs.bash = {
    enable = true;
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
