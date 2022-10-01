# TODO: I should rename this but I am not really sure yet. file-extensions.nix?
{
  programs.emacs.init.usePackage = {
    python = {
      enable = true;
      # TODO: Set "python3" using a Nix expression such as config.python3
      config = ''
        (setq python-shell-interpreter "python3")
        (setq dap-python-executable "python3")
        (setq dap-python-debugger 'debugpy)
      '';
    };

    nix-mode = {
      enable = true;
      mode = [ ''"\\.nix\\'"'' ];
    };

    terraform-mode = { enable = true; };

    dockerfile-mode = { enable = true; };

    yaml-mode = { enable = true; };

    csv-mode = {
      enable = true;
      hook = [
        "(csv-mode . csv-align-mode)"
        "(csv-mode . csv-guess-set-separator)"
      ];
    };

    git-modes = {
      enable = true;
      mode = [ ''("\\.dockerignore\\'" . 'gitignore-mode)'' ];
    };
  };
}
