let leaderKey = "SPC";
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

        (defun band-aid-org-roam-capture-template (keybinding name)
          `(,keybinding
            ,name
            plain
            (file ,(expand-file-name (concat name ".org")))
            :if-new (file "%<%Y%m%d%H%M%S>.org")
            :unnarrowed t))

        (defun band-aid-org-roam-set-templates (template-directory)
          (let ((default-directory template-directory))
            (setq org-roam-capture-templates
            (list (band-aid-org-roam-capture-template "d" "default")
            (band-aid-org-roam-capture-template "i" "index")
            (band-aid-org-roam-capture-template "f" "facts")
            (band-aid-org-roam-capture-template "b" "inbox")
            (band-aid-org-roam-capture-template "a" "appendix")))))

        (band-aid-org-roam-set-templates
          (expand-file-name "templates" (getenv "ORG_DIRECTORY")))
      '';
      general = [''
        (:states 'normal
         "${leaderKey} r"   '(:ignore t :which-key "org-roam")
         "${leaderKey} rb"  'org-roam-buffer-toggle
         "${leaderKey} rn"  '(:ignore t :which-key "node")
         "${leaderKey} rnf" 'org-roam-node-find
         "${leaderKey} rni" 'org-roam-node-insert
         "${leaderKey} rnr" 'org-roam-node-random
         "${leaderKey} ra"  '(:ignore t :which-key "alias")
         "${leaderKey} raa" 'org-roam-alias-add
         "${leaderKey} rar" 'org-roam-alias-remove
         "${leaderKey} rr"  '(:ignore t :which-key "ref")
         "${leaderKey} rra" 'org-roam-ref-add
         "${leaderKey} rrr" 'org-roam-ref-remove
         "${leaderKey} rt"  '(:ignore t :which-key "tag")
         "${leaderKey} rta" 'org-roam-tag-add
         "${leaderKey} rtr" 'org-roam-tag-remove
         "${leaderKey} ra"  '(:ignore t :which-key "add"))
      ''];
    };

    org-roam-bibtex = { enable = true; };

    org-roam-ui = {
      enable = true;
      after = [ "org-roam" ];
      diminish = [ "org-roam-ui-mode" ];
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
      diminish = [ "org-roam-timestamps-mode" ];
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
        (:states 'normal
         "${leaderKey} rd" 'deft)
      ''];
    };

    # Does not exist on emacs-overlay.
    delve = {
      enable = false;
      after = [ "org-roam" ];
    };
  };
}
