{
  programs.emacs.init.usePackage = {
    vertico = {
      enable = true;
      hook = [ "(after-init . vertico-mode)" ];
      custom = { vertico-count = "5"; };
    };

    vertico-buffer = {
      enable = true;
      after = [ "vertico" ];
      hook = [ "(vertico-mode . vertico-buffer-mode)" ];
      custom = {
        vertico-buffer-display-action = ''
          `(display-buffer-in-side-window
            (window-height . ,(+ 3 vertico-count))
            (side . top))
        '';
      };
    };

    orderless = {
      enable = true;
      custom = {
        completion-styles = "'(orderless)";
        completion-category-defaults = "nil";
        completion-category-overrides =
          "'((file (styles . (partial-completion))))";
        orderless-matching-styles = "'(orderless-prefixes)";
      };
    };

    consult = { enable = true; };

    marginalia = {
      enable = true;
      hook = [ "(after-init . marginalia-mode)" ];
    };

    embark = {
      enable = false;
      general = [''
        (("C-." embark-act)
        ("M-." embark-dwim)
        ("C-h B" embark-bindings))
      ''];
    };

    embark-consult = { enable = false; };

    corfu = {
      enable = true;
      hook = [ "(after-init . global-corfu-mode)" ];
      custom = {
        corfu-auto = "t";
        corfu-auto-prefix = "2";
        corfu-cycle = "t";
        corfu-auto-delay = "0.1";
      };
    };

    prescient = {
      enable = true;
      config = "(prescient-persist-mode 1)";
    };

    which-key = {
      enable = true;
      hook = [ "(after-init . which-key-mode)" ];
    };

    helpful = {
      enable = true;
      custom = {
        describe-function-function = "#'helpful-callable";
        describe-variable-function = "#'helpful-variable";
      };
    };
  };
}
