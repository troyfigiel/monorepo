{ config, pkgs, ... }:

{
  home.username = "troy";
  home.homeDirectory = "/home/troy";

  home.packages = with pkgs; [
    vim
    emacs
    tldr
    git
    nitrokey-app
    paperkey
    direnv
    #sshfs
    #gpg2
    #pass
    #flameshot
    pandoc
  ];

  home.sessionVariables = {
    EDITOR = "vim";
  };

  home.sessionPath = [
    "$HOME/.local/bin"    
  ];

  home.stateVersion = "22.05";

  targets.genericLinux.enable = true;

  programs.home-manager.enable = true;

  programs.bash = {
    enable = true;
    profileExtra = ''
      . ~/nixfiles/config/profile
    '';
    bashrcExtra = ''
      . ~/nixfiles/config/bashrc
    '';
    logoutExtra = ''
      . ~/nixfiles/config/bash_logout
    '';
  };

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

  systemd.user.services = {
    clone-emacs-config = {
      Unit = {
        Description = "Service that clones my Emacs config to .emacs.d";
      };

      Service = {
        Type = "oneshot";
        ExecStart = "${pkgs.git}/bin/git clone git@gitlab.com:troy.figiel/emacs.git /home/troy/.emacs.d";
      };
    };

    clone-notes = {
      Unit = {
        Description = "Service that clones my Zettelkasten notes";
      };

      Service = {
        Type = "oneshot";
        ExecStart = "${pkgs.git}/bin/git clone git@gitlab.com:troy.figiel/zettelkasten.git /home/troy/zettelkasten";
      };
    };
  };

  home.file = {
    ".config/user-dirs.dirs".source = ./config/user-dirs.dirs;
    ".config/user-dirs.locale".source = ./config/user-dirs.locale;
    ".config/direnv".source = ./config/direnv;
    ".config/pypoetry".source = ./config/pypoetry;
    ".gnupg/gpg.conf".source = ./config/gnupg/gpg.conf;
    ".gnupg/gpg-agent.conf".source = ./config/gnupg/gpg-agent.conf;
  };
}
