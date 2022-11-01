{
  programs.emacs.init.usePackage = {
    org = {
      config = ''
        ;; TODO: Create a simple binding for previewing the entire buffer in LaTeX
        ;; TODO: This should be org-cdlatex-mode, but can't get it to work.
        ;; TODO: Does this work as a custom or does it need to be a default?
        (add-to-list 'org-structure-template-alist '("el" . "src emacs-lisp"))
        (add-to-list 'org-structure-template-alist '("py" . "src python"))
        (add-to-list 'org-structure-template-alist '("sh" . "src shell"))
        (add-to-list 'org-structure-template-alist '("r" . "src R"))
        (add-to-list 'org-structure-template-alist '("sh" . "src shell"))
        (add-to-list 'org-structure-template-alist '("sq" . "src sql"))
        (org-babel-do-load-languages
         'org-babel-load-languages
         '((emacs-lisp . t)
           (python . t)
           (shell . t)
           (R . t)
           (sql . t)))
        (push '("conf-unix" . conf-unix) org-src-lang-modes)
      '';
    };
  };
}
