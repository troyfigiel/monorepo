{ pkgs, ... }:

{
  programs.emacs.init.usePackage = {
    tex-mode = {
      enable = true;
      hook = [
        "(LaTeX-mode . prettify-symbols-mode)"
        "(LaTeX-mode . TeX-fold-mode)"
        "(LaTeX-mode . latex-preview-pane-mode)"
      ];
      custom = {
        TeX-auto-save = "t";
        TeX-parse-self = "t";
      };
      extraPackages = [ pkgs.texlive.combined.scheme-full ];
    };

    cdlatex = {
      enable = true;
      after = [ "tex" ];
      custom = {
        cdlatex-math-modify-prefix = "?'";
        cdlatex-math-symbol-prefix = "?§";
        cdlatex-math-modify-alist = '''((?a "\\mathbb" nil t nil nil))'';
        cdlatex-env-alist = ''
          '(("theorem" "\\begin{theorem}\nAUTOLABEL\n?\n\\end{theorem}\n" nil))
        '';
        cdlatex-command-alist = ''
          '(("thr" "Insert theorem env" "" cdlatex-environment ("theorem") t nil))
        '';
      };
      general = [''
        (:keymaps 'cdlatex-mode-map
         "C-c e" 'cdlatex-environment
         "'" 'cdlatex-math-modify
         "§" 'cdlatex-math-symbol)
      ''];
    };
  };
}
