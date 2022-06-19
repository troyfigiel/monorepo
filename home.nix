{ config, pkgs, ... }:

{
  home.username = "troy";
  home.homeDirectory = "/home/troy";

  home.packages = [
    pkgs.vim
    pkgs.emacs
    pkgs.tldr
    pkgs.git
    pkgs.nitrokey-app
    pkgs.paperkey
    #pkgs.direnv
    #pkgs.sshfs
    #pkgs.gpg2
    #pkgs.pass
    #pkgs.flameshot
    pkgs.pandoc
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

    clone-asdf = {
      Unit = {
        Description = "Services that clones asdf";
      };

      Service = {
        Type = "oneshot";
        ExecStart = "${pkgs.git}/bin/git clone https://github.com/asdf-vm/asdf.git /home/troy/.asdf --branch v0.10.0";
      };
    };
  };

  home.file = {
    ".config/user-dirs.dirs".source = ./config/user-dirs.dirs;
    ".config/user-dirs.locale".source = ./config/user-dirs.locale;
    #".config/asdf-direnv".source = ./config/asdf-direnv;
    ".config/direnv".source = ./config/direnv;
    ".config/pypoetry".source = ./config/pypoetry;
    ".gnupg/gpg.conf".source = ./config/gnupg/gpg.conf;
    ".gnupg/gpg-agent.conf".source = ./config/gnupg/gpg-agent.conf;
    ".tool-versions".source = ./config/tool-versions;
  };
}
