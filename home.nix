{ config, pkgs, ... }:

{
  home.username = "troy";
  home.homeDirectory = "/home/troy";

  home.packages = [
    pkgs.vim
    pkgs.tldr
    pkgs.git
    pkgs.nitrokey-app
    pkgs.paperkey
    #pkgs.sshfs
    #pkgs.gpg2
    #pkgs.pass
    #pkgs.flameshot
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
  };

  home.file = {
/* We should just use nix itself for this. It's pretty simple
    ".asdf".source = pkgs.fetchFromGitHub {
      # This needs to be writable somehow to set up Python and Terraform with asdf
      owner = "asdf-vm";
      repo = "asdf";
      rev = "v0.10.1";
      sha256 = "sha256-WXFGOlj1uHEVvmH/Z87wa6wbChzQQ5Kh4Ra4RwBacdw=";
    };
*/
    ".config/user-dirs.dirs".source = ./config/user-dirs.dirs;
    ".config/user-dirs.locale".source = ./config/user-dirs.locale;
    #".config/asdf-direnv".source = ./config/asdf-direnv;
    ".config/pypoetry".source = ./config/pypoetry;
    ".gnupg/gpg.conf".source = ./config/gnupg/gpg.conf;
    ".gnupg/gpg-agent.conf".source = ./config/gnupg/gpg-agent.conf;
  };
}
