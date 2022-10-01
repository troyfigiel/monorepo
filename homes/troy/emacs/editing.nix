{
  programs.emacs.init.usePackage = {
    undo-fu = { enable = true; };
    undo-fu-session = { enable = true; };
    vundo = { enable = true; };
    default-text-scale = { enable = true; };

    page-break-lines = {
      enable = true;
      config = "(global-page-break-lines-mode 1)";
    };

    flyspell = {
      enable = true;
      hook =
        [ "(text-mode . flyspell-mode)" "(prog-mode . flyspell-prog-mode)" ];
    };

    whitespace-cleanup-mode = {
      enable = true;
      hook = [ "prog-mode" "text-mode" ];
    };
  };
}
