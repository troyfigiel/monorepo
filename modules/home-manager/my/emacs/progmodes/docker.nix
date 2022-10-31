let leaderKey = "C-c";
in {
  programs.emacs.init.usePackage = {
    docker = {
      enable = true;
      general = [ ''(:prefix "${leaderKey}" "d" 'docker)'' ];
    };

    dockerfile-mode = { enable = true; };

    docker-compose-mode = { enable = true; };

    lsp-mode = {
      extraPackages = [
        # pkgs.docker-langserver
      ];
    };

    git-modes = { mode = [ ''("\\.dockerignore\\'" . 'gitignore-mode)'' ]; };
  };
}
