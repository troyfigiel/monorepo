;;; -*- lexical-binding: t -*-

;; This package remembers where the point was when the buffer was last visited.
(use-package saveplace
  :custom (save-place-mode 1))

;; This package saves the minibuffer history.
(use-package savehist
  :custom (save-hist-mode 1))

;; I do not like the automatic save after idling, because if I am typing,
;; pause at a space or tab and wait for too long, whitespace-cleanup-mode
;; will remove the space again. This can be annoying.
;; Generally speaking though, I don't pause after a space very often anyway.
(use-package super-save
  ;; This hook ensures we do not need to click yes on the prompt asking us to save
  ;; when we try to quit Emacs.
  ;; Setting the default has the drawback that is tries to save also non-file buffers
  ;; such as the minibuffer. Hooking this after `find-file` will prevent this issue.
  ;; Since auto-save-mode is enabled by default, if Emacs ever crashes, we still have
  ;; the backups to recover from.
  ;; IDEA: Maybe do not change the colour of the filename if it needs saving anymore.
  ;; We are automatically saving anyway at every opportunity.
  :hook (find-file . (lambda () (setq buffer-save-without-query t)))
  :custom (super-save-mode 1))

;; There is a persistent-scratch-mode which remaps the save and write buffer
;; to their persistent-scratch counterparts. Should I hook this somehow?
;; No, not necessary. I shouldn't be trying to save automatically anyway.
;; super-save will do that for me automatically.
(use-package emacs
  :straight (:type built-in)
  :custom (initial-scratch-message nil))

;; We protect the scratch buffer from accidentally being killed.
;; And if it does not exist, create it.
(use-package protbuf
  :custom (protect-buffer-bury-p nil)
  :config
  ;; The scratch buffer SHOULD exist at this point. If it does not, I want to run into an error.
  (protect-buffer-from-kill-mode 1 (get-buffer "*scratch*")))

(use-package persistent-scratch
  :custom
  (persistent-scratch-backup-directory
   (concat (file-name-as-directory no-littering-var-directory)
	   "persistent-scratch-backups"))
  ;; I do not use persistent-scratch-default-setup because it is not idempotent.
  ;; It toggles persistent-scratch-autosave-mode instead of setting it to t.
  (persistent-scratch-autosave-mode 1)
  :config
  ;; I am running this code only because it is a habit to call C-x C-s to save.
  ;; I want to be able to do this in the scratch buffer as well without being
  ;; asked to open a file to save to contents in.
  ;; It does not work though, not sure why not. Maybe better to not have it anyway? Autosave-mode works fine.
  ;; (with-current-buffer (get-buffer "*scratch*")
  ;;   (persistent-scratch-mode 1))
  (persistent-scratch--auto-restore))

;; (use-feature band-aid
;; :general
;; (:states 'normal
;;  :prefix core-keybindings-leader-key
;; IDEA: "ss" switch to scratch buffer
;; "sn" 'band-aid-scratch))

(provide 'config/01_persistence)
