let leaderKey = "C-SPC";
in {
  programs.emacs.init.usePackage = {
    org-roam = {
      enable = true;
      after = [ "org" ];
      custom = {
        org-roam-directory =
          ''(expand-file-name "notes" (getenv "ORG_DIRECTORY"))'';
        org-roam-completion-everywhere = "t";
      };
      config = ''
        (org-roam-db-autosync-enable)

        ;; (defun band-aid-org-roam-capture-template (keybinding name)
        ;;   `(,keybinding
        ;;     ,name
        ;;     plain
        ;;     (file ,(expand-file-name (concat name ".org")))
        ;;     :if-new (file "%<%Y%m%d%H%M%S>.org")
        ;;     :unnarrowed t))

        ;; (defun band-aid-org-roam-set-templates (template-directory)
        ;;   (let ((default-directory template-directory))
        ;;     (setq org-roam-capture-templates
        ;;     (list (band-aid-org-roam-capture-template "d" "default")
        ;;     (band-aid-org-roam-capture-template "i" "index")
        ;;     (band-aid-org-roam-capture-template "f" "facts")
        ;;     (band-aid-org-roam-capture-template "b" "inbox")
        ;;     (band-aid-org-roam-capture-template "a" "appendix")))))

        ;; (band-aid-org-roam-set-templates
        ;;   (expand-file-name "templates" (getenv "ORG_DIRECTORY")))
      '';
      general = [''
        (:prefix "${leaderKey}"
         "rb"  'org-roam-buffer-toggle
         "rf" 'org-roam-node-find
         "ri" 'org-roam-node-insert
         "rd" 'org-roam-node-random
         "ra"  '(:ignore t :which-key "alias")
         "ra"  '(:ignore t :which-key "add")
         "raa" 'org-roam-alias-add
         "rar" 'org-roam-ref-add
         "rat" 'org-roam-tag-add
         "rr"  '(:ignore t :which-key "remove")
         "rra" 'org-roam-alias-remove
         "rrr" 'org-roam-ref-remove
         "rrt" 'org-roam-tag-remove)
      ''];
    };

    org-roam-bibtex = { enable = true; };

    org-roam-ui = {
      enable = true;
      after = [ "org-roam" ];
      hook = [ "(after-init . org-roam-ui-mode)" ];
      custom = {
        org-roam-ui-sync-theme = "t";
        org-roam-ui-follow = "t";
        org-roam-ui-update-on-save = "t";
        org-roam-ui-open-on-start = "nil";
      };
    };

    org-roam-timestamps = {
      enable = true;
      after = [ "org-roam" ];
      hook = [ "(after-init . org-roam-timestamps-mode)" ];
      custom = { org-roam-timestamps-remember-timestamps = "nil"; };
    };

    deft = {
      enable = true;
      after = [ "org-roam" ];
      custom = {
        deft-recursive = "t";
        deft-use-filter-string-for-filename = "t";
        deft-default-extension = ''"org"'';
        deft-directory = "org-roam-directory";
      };
      general = [''
        (:prefix "${leaderKey}" "rs" 'deft)
      ''];
    };
  };
}
