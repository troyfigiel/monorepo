(use-package direnv
  :custom (direnv-mode 1))

(use-package asdf
  :straight (:type git :host github :repo "tabfugnic/asdf.el")
  :custom
  (asdf-path
   (concat (file-name-as-directory no-littering-var-directory) "asdf"))
  (asdf-binary
   (concat (file-name-as-directory asdf-path) "bin/asdf"))
  :config
  (setenv "ASDF_DIR" asdf-path)
  (setenv "ASDF_DATA_DIR" asdf-path)
  (band-aid-git-clone "https://github.com/asdf-vm/asdf.git"
		    asdf-path
		    "--branch v0.10.0")
  (asdf-enable)
  :general
  (:states 'normal
   :prefix core-keybindings-leader-key
   "a" 'asdf))

  (use-feature patches/01_asdf-reshim :after asdf)
  (use-feature patches/01_asdf-transient :after asdf)

;; TODO: Is `project-execute-extended-command' something I will use regularly?
;; TODO: How would I set up automatic testing? Should I use firestarter or just
;; reuse `project-compile'?
;; TODO: Browse dirty projects could be very useful. How do I create this for project?
(use-package project
  :config
  (transient-define-prefix project-transient ()
    "project.el transient menu."
    [["Buffers"
      ("b" "Switch to project buffer" project-switch-to-buffer)
      ("k" "Kill project buffers" project-kill-buffers)]
     ["Search"
      ("f" "Find file in project" project-find-file)
      ("F" "Find file in project or external roots" project-or-external-find-file)
      ("g" "Find regexp in project" project-find-regexp)
      ("G" "Find regexp in project or external roots" project-or-external-find-regexp)
      ("R" "Find and replace regexp" project-query-replace-regexp)]
     ["Shell"
      ("s" "Start" project-shell)
      ("!" "Run command" project-shell-command)
      ("&" "Run async command" project-async-shell-command)]
     ["Manage"
      ("D" "Open dired at project root" project-dired)
      ("m" "Open magit status at project root" magit-project-status)
      ("c" "Compile Project" project-compile)
      ("p" "Switch Project" project-switch-project)]])
  :general
  (:states 'normal
   :prefix core-keybindings-leader-key
   "p" 'project-transient))

(use-package smartparens
  :hook (prog-mode . smartparens-mode))

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))
