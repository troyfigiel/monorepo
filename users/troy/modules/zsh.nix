{
  programs.zsh = {
    enable = true;
    enableVteIntegration = true;

    autocd = true;
    dirHashes = { docs = "$HOME/Documents"; };
    enableCompletion = true;
    enableAutosuggestions = true;
    enableSyntaxHighlighting = true;

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
