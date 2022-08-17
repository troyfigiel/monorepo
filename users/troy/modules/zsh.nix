{ lib, pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    enableVteIntegration = true;

    autocd = true;
    dirHashes = { docs = "$HOME/Documents"; };
    enableCompletion = true;
    enableAutosuggestions = true;
    enableSyntaxHighlighting = true;

    # TODO: Use plugins like this, but replace the fetchGit by Flakes.
    # How does that work? https://nixos.wiki/wiki/Flakes
    # TODO: Do I still need to activate these plugins?
    plugins = [
      {
        name = "zsh-colored-man-pages";
        src = pkgs.fetchFromGitHub {
          owner = "ael-code";
          repo = "zsh-colored-man-pages";
          rev = "57bdda68e52a09075352b18fa3ca21abd31df4cb";
          sha256 = "sha256-087bNmB5gDUKoSriHIjXOVZiUG5+Dy9qv3D69E8GBhs=";
        };
      }
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
      t = "tldr";
      grep = "grep --color=auto";
      ip = "ip --color=auto";
      ld = "lazydocker";
      lg = "lazygit";
    };
  };
}
