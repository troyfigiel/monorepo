{
  programs.emacs.init.usePackage = {
    toc-org = { hook = [ "(markdown-mode . toc-org-mode)" ]; };
    olivetti = { hook = [ "(markdown-mode . olivetti-mode)" ]; };
  };
}
