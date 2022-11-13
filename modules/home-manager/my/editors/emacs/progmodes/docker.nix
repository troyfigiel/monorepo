let leaderKey = "C-c";
in {
  programs.emacs.init.usePackage = {
    docker = {
      enable = true;
      general = [ ''(:prefix "${leaderKey}" "d" 'docker)'' ];
    };

    dockerfile-mode = { enable = true; };

    docker-compose-mode = { enable = true; };

    eglot = {
      extraPackages = [
        # pkgs.docker-langserver
      ];
    };

    docker-tramp = { enable = true; };

    git-modes = { mode = [ ''("\\.dockerignore\\'" . 'gitignore-mode)'' ]; };
  };
}
