;;; -*- lexical-binding: t -*-

(use-package vertico
  ;; Vertico stores its extensions in a separate directory.
  ;; Straight needs to be able to find this directory.
  :straight
  (:files (:defaults "extensions/*")
   :includes
   (vertico-buffer
    vertico-directory
    vertico-flat
    vertico-indexed
    vertico-mouse
    vertico-quick
    vertico-repeat
    vertico-reverse))
  ;; BUG: It seems `vertico-count' set to 5 does not work with `vertico-buffer'.
  ;;:custom (vertico-count 5)
  :config (vertico-mode 1))

(use-feature vertico-buffer
  :after vertico
  :custom
  ;; The confusing thing is that the buffer is still underneath the rest when using windmove.
  (vertico-buffer-display-action
   `(display-buffer-in-side-window
     (window-height . ,(+ 3 vertico-count))
     (side . top)))
  (vertico-buffer-mode 1))

(use-feature vertico-directory
  :after vertico
  ;; TODOC: What is the `rfn-eshadow-update-overlay-hook' and when does it trigger?
  ;; TODOC: What does the `vertico-directory-tidy' function do?
  :hook (rfn-eshadow-update-overlay . vertico-directory-tidy)
  ;; IDEA: I should rewrite this with the general package. Which keybindings would make sense?
  :bind
  (:map vertico-map
   ("RET" . vertico-directory-enter)
   ("DEL" . vertico-directory-delete-char)
   ("M-DEL" . vertico-directory-delete-word)))

(use-package orderless
  :custom
  (completion-styles '(orderless))
  (completion-category-defaults nil)
  (completion-category-overrides '((file (styles . (partial-completion)))))
  ;; orderless-flex ends up giving too many candidates.
  (orderless-matching-styles '(orderless-prefixes)))

;; consult-find
;; consult-ripgrep
;; consult-yank are useful functions.
(use-package consult)

(use-package marginalia
  :custom (marginalia-mode 1))

;; IDEA: To start understanding how I could use embark, I should put together a number of examples.
;; - Open a file by selecting the text and running embark-act on it.
(use-package embark
  :bind
  (("C-." . embark-act)
   ("M-." . embark-dwim)
   ("C-h B" . embark-bindings)))

(use-package embark-consult)

(use-package ace-window
  :custom
  (aw-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l))
  :general
  ("s-w" 'ace-window))

;; There are some other useful functions that I could bind. I need to think about them.
;; BUG: Capital letters seem to be counted as two different matches.
(use-package ctrlf
  :custom
  ;; So I can search multiple words separated by spaces.
  ;; If I ever need to search for a space, double space works.
  (ctrlf-default-search-style 'fuzzy)
  ;; So I can search and immediately change a word by going to the beginning.
  (ctrlf-go-to-end-of-match nil)
  (ctrlf-mode 1)
  :general
  ;; IDEA: I need better keypresses, because these are inconvient to press. What are some better options?
  ("s-g" 'ctrlf-forward-default)
  (:keymaps 'ctrlf-mode-map
   "s-j" 'ctrlf-forward-default
   "s-k" 'ctrlf-backward-default))

(use-package corfu
  :custom
  (corfu-auto t)
  (corfu-auto-prefix 2)
  (corfu-cycle t)
  (corfu-auto-delay 0.1)
  :config (global-corfu-mode 1))

(use-package prescient
  :config (prescient-persist-mode 1))

;; Can helpful be replaced somehow?
;; (use-package helpful
;;   :custom
;;   (describe-function-function #'helpful-callable)
;;   (describe-variable-function #'helpful-variable))

(use-package which-key
  :config (which-key-mode 1))

(provide 'config/01_completion)
