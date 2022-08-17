{ lib, pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    enableVteIntegration = true;

    autocd = true;

    dirHashes = {
        do = "$HOME/Documents";
        dl = "$HOME/Downloads";
        pr = "$HOME/Projects";
        nc = "$HOME/Projects/nixos-config";
    };

    # TODO: How to set case-insensitive completion?
    # TODO: zsh has a nice completion style where it brings up a menu to select from.
    # How do I activate this with Nix? Something like zstyle ':completion:*' menu select.
    # TODO: How do I set up a bindkey to open a line in vim?
    # TODO: How do I use lf to switch directories instead of cd?
    # TODO: How can I add abbreviations to zsh? See https://github.com/olets/zsh-abbr
    enableCompletion = true;
    enableAutosuggestions = true;
    enableSyntaxHighlighting = true;

    plugins = [
    # TODO: I have not been able to make this plugin work yet.
    #   {
    #     name = "pass-zsh-completion";
    #     src = pkgs.fetchFromGitHub {
    #       owner = "ninrod";
    #       repo = "pass-zsh-completion";
    #       rev = "e4d8d2c27d8999307e8f34bf81b2e15df4b76177";
    #       sha256 = "sha256-KfZJ9XxZ8cBePcJPOAPQZ+f5kVUgLExDw/5QSduDA/0=";
    #     };
    #   }
      {
        name = "zsh-colored-man-pages";
        file = "colored-man-pages.plugin.zsh";
        src = pkgs.fetchFromGitHub {
          owner = "ael-code";
          repo = "zsh-colored-man-pages";
          rev = "57bdda68e52a09075352b18fa3ca21abd31df4cb";
          sha256 = "sha256-087bNmB5gDUKoSriHIjXOVZiUG5+Dy9qv3D69E8GBhs=";
        };
      }
      # TODO: Powerlevel10k is actually overkill in my opinion. Maybe I should set a nice PS1 and not use it.
      # TODO: Set cursor as straight line for insert mode and block for normal / visual mode.
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
      {
        name = "powerlevel10k-config";
        src = lib.cleanSource ./config;
        file = "p10k.zsh";
      }
    ];

    shellAliases = {
      # TODO: Some aliases for Nix?
      grep = "grep --color=auto";
      df = "df -h";
      ls = "ls --color=auto -h";
      ld = "lazydocker";
      lg = "lazygit";
      # Yank to system clipboard
      clip = "xclip -selection clipboard";
    };
  };
}
