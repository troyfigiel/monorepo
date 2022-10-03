{
  programs.emacs.init.usePackage = {
    vertico = {
      enable = true;
      config = "(vertico-mode 1)";
    };

    orderless = {
      enable = true;
      config = ''
        (setq completion-styles '(orderless))
        (setq completion-category-defaults nil)
        (setq completion-category-overrides '((file (styles . (partial-completion)))))
        (setq orderless-matching-styles '(orderless-prefixes))
      '';
    };

    consult = { enable = true; };

    marginalia = {
      enable = true;
      config = "(marginalia-mode 1)";
    };

    embark = { enable = true; };

    embark-consult = { enable = true; };

    ace-window = {
      enable = true;
      config = ''
        (setq aw-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l))
      '';
    };

    corfu = {
      enable = true;
      config = ''
        (setq corfu-auto t)
        (setq corfu-auto-prefix 2)
        (setq corfu-cycle t)
        (setq corfu-auto-delay 0.1)
        (global-corfu-mode 1)
      '';
    };

    prescient = {
      enable = true;
      config = "(prescient-persist-mode 1)";
    };

    which-key = {
      enable = true;
      config = "(which-key-mode 1)";
    };
  };
}
