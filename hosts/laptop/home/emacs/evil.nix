{
  programs.emacs.init.usePackage = {
    evil = {
      enable = true;
      config = ''
        (setq evil-want-C-u-scroll t)
        (setq evil-want-C-i-jump nil)
        (setq evil-undo-system 'undo-tree)
        (setq evil-mode-line-format nil)
        (evil-mode 1)
      '';
    };

    evil-escape = {
      enable = true;
      config = ''
        (setq evil-escape-unordered-key-sequence t)
        (setq evil-escape-key-sequence ".,")
        (setq evil-escape-delay 0.2)
        (evil-escape-mode 1)
      '';
    };

    evil-nerd-commenter = { enable = true; };
  };
}
