{ pkgs, ... }:

let leaderKey = "C-c";
in {
  programs.emacs.init.usePackage = {
    lsp-mode = {
      enable = true;
      hook = [ "(lsp-mode . lsp-enable-which-key-integration)" ];
      custom = { lsp-keymap-prefix = ''"${leaderKey} l"''; };
    };

    lsp-completion = { enable = true; };

    # TODO: With lsp-docker I should be able to implement a workflow similar to vscodes devcontainers.
    lsp-docker = { enable = true; };

    lsp-diagnostics = { enable = true; };

    lsp-headerline = { enable = true; };

    lsp-lens = { enable = true; };

    lsp-modeline = { enable = true; };

    lsp-protocol = { enable = true; };

    lsp-semantic-tokens = { enable = true; };

    lsp-treemacs = { enable = true; };

    lsp-ui = { enable = true; };

    consult-lsp = { enable = true; };

    dap-mode = { enable = true; };

    dap-ui = { enable = true; };

    dap-mouse = { enable = true; };
  };
}
