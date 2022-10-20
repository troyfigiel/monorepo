;; BUG: I keep running into a bug here with some wrong types. This is
;; more annoying than helpful.
;; (use-package explain-pause-mode :custom
;;   (explain-pause-mode 1))

;; IDEA: It seems bug-hunter does not handle the existence of
;; early-init.el. It will just load and bissect init.el on an empty
;; Emacs instance. Potentially, I could fix this, because it does not
;; sound too difficult. (use-package bug-hunter)
