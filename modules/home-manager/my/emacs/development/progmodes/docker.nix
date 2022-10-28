let leaderKey = "SPC";
in {
  programs.emacs.init.usePackage = {
    # TODO: With lsp-docker I should be able to implement a workflow similar to vscodes devcontainers.
    lsp-docker = { enable = true; };

    docker = {
      enable = true;
      general = [''
        (:states 'normal
         "${leaderKey} d" 'docker)
      ''];
    };

    dockerfile-mode = { enable = true; };

    docker-compose-mode = { enable = true; };

    eglot = {
      extraPackages = [
        # pkgs.docker-langserver
      ];
    };

    git-modes = { mode = [ ''("\\.dockerignore\\'" . 'gitignore-mode)'' ]; };
  };
}
