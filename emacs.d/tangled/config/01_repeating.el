(use-package repeat
  :config (repeat-mode 1))

;; The default popup-type for repeat-help uses embark, not which-key.
(use-package repeat-help
  :after (repeat embark)
  :custom (repeat-help-auto t)
  ;; IDEA: I can actually also hook repeat-help-mode after repeat-mode
  ;; and hook repeat-mode into the after-init hook. Would that be nicer?
  ;; Potentially, because it is more descriptive.
  ;; And can I do this for other modes as well?
  :config (repeat-help-mode 1))

(use-package define-repeat-map
  :straight
  (:type git
   :host nil
   :repo "https://tildegit.org/acdw/define-repeat-map.el")
  :after repeat)
