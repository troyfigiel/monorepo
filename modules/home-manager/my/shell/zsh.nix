{ config, lib, ... }:

with lib;
let cfg = config.my.zsh;
in {
  options.my.zsh.enable = mkEnableOption "zsh";

  config = mkIf cfg.enable (mkMerge [{
    programs.zsh = {
      enable = true;
      enableVteIntegration = true;

      autocd = true;
      defaultKeymap = "emacs";
      enableCompletion = true;
      enableAutosuggestions = true;
      enableSyntaxHighlighting = true;
      initExtraFirst = "zstyle ':completion:*' menu select";
      sessionVariables.PS1 =
        "%B%F{yellow}%n%F{white}@%F{green}%M%F{white}:%F{blue}%~%F{white} >%b%{$reset_colors%} ";

      # TODO: Enable based on the values of my.directories
      dirHashes = {
        au = config.xdg.userDirs.music;
        pi = config.xdg.userDirs.pictures;
        do = config.xdg.userDirs.documents;
        dl = config.xdg.userDirs.download;
        pr = config.xdg.userDirs.extraConfig.XDG_PROJECTS_DIR;
        mr =
          "${config.xdg.userDirs.extraConfig.XDG_PROJECTS_DIR}/private/monorepo";
        sh = config.xdg.userDirs.publicShare;
        vi = config.xdg.userDirs.videos;
      };

      shellAliases = {
        grep = "grep --color=auto";
        ls = "ls --color=auto -h";
        lg = "lazygit";
        mv = "mv -i"; # Ask before overwriting
        ec = "emacsclient -cn";
        et = "emacsclient -t";
      };
    };

    programs.fzf = {
      enable = true;
      enableZshIntegration = true;
    };
  }

  # TODO: For some reason this does not work nicely. After a while during my session, the symlink has been replaced by a completely new .zsh_history file.
  # I am not sure why that happens.
  # (optionalAttrs impermanence {
  #   home.persistence."/nix/persist/${config.home.homeDirectory}" = {
  #     files = [ ".zsh_history" ];
  #     allowOther = true;
  #   };
  # })
    ]);
}
