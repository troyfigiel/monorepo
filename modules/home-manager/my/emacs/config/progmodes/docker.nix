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

    docker-tramp = {
      enable = true;
      # TODO: This sets a default higher verbosity for TRAMP. Might be good to have it at this level until I understand when what gets triggered.
      custom = { tramp-verbose = "6"; };
    };

    git-modes = { mode = [ ''("\\.dockerignore\\'" . 'gitignore-mode)'' ]; };
  };
}
