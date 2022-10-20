;; pylsp-rope supposedly contains some nice refactoring capabilities
(use-package python
  :config
  ;; We can use the :interpreter keyword
  (setq python-shell-interpreter "python3"
	dap-python-executable "python3"
	dap-python-debugger 'debugpy)
  :general
  (:states 'normal
   :prefix core-keybindings-leader-key
   "l"  '(:ignore t :which-key "languages")
   "lp" '(:ignore t :which-key "python")))

;; IDEA: Is poetry not enough? Do I still need pyvenv?
(use-package pyvenv
  ;; TODO: The venv in the modeline does not look very nice. Can I give it a different face?
  :config (pyvenv-mode 1)
  :general
  (:states 'normal
   :prefix core-keybindings-leader-key
   "lpv"  '(:ignore t :which-key "pyvenv")
   "lpva" 'pyvenv-activate
   "lpvd" 'pyvenv-deactivate))

(use-package poetry
  :general
  (:states 'normal
   :prefix core-keybindings-leader-key
   "lpp" 'poetry))
