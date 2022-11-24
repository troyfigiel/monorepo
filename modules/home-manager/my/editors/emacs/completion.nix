{ pkgs, ... }:

{
  programs.emacs.init.usePackage = {
    # Cycling through inputs is done with C-n and C-p by default.
    vertico = {
      enable = true;
      hook = [ "(after-init . vertico-mode)" ];
      custom = { vertico-cycle = "t"; };
    };

    vertico-flat = {
      enable = true;
      after = [ "vertico" ];
      hook = [ "(vertico-mode . vertico-flat-mode)" ];
    };

    orderless = {
      enable = true;
      custom = {
        completion-styles = "'(orderless)";
        completion-category-defaults = "nil";
        completion-category-overrides =
          "'((file (styles . (partial-completion))))";
        # TODO: The completion style is a bit harsh. If I type "con grep" I also want to match consult-ripgrep. But "con con" should not match anything consult-related. The second part should match a different word. How do I achieve this?
        orderless-matching-styles = "'(orderless-prefixes)";
      };
    };

    recentf = {
      enable = true;
      # TODO: I should bind a key to recentf-cleanup. Sometimes there are numerous recent files pointing to non-existing paths, such as when happens when Docker containers get removed.
      custom = {
        # It can be difficult to find what I am looking for with the low default values.
        # TODO: What does the recentf-max-menu-items option exactly change?
        # recentf-max-menu-items = "50";
        recentf-auto-cleanup = "'never";
        recentf-max-saved-items = "200";
      };
      # It is important to turn recentf-auto-cleanup to never *before* setting turning on recentf-mode.
      # By default recentf will run an auto-cleanup when turning on recentf-mode.
      config = ''
        (setq recentf-auto-cleanup 'never)
        (recentf-mode 1)
        (run-at-time nil 300 'recentf-save-list)
      '';
    };

    consult-dir = {
      enable = true;
      hook = [ "(after-init . recentf-mode)" ];
      custom = { consult-dir-shadow-filenames = "nil"; };
      after = [ "consult" ];
      # I can use Embark for any other action, e.g. jumping to a file, ripgrep or whatever other action I want to take.
      general = [''
        (:keymaps 'override
         "C-x C-d" #'consult-dir)
      ''];
      # TODO: This requires docker-tramp to be installed. How to make the dependency explicit? See: (require 'docker-tramp nil t)
      # TODO: To get the same for SSH, I need to create a .ssh/config file containing my hosts.
      config = ''
        (defun consult-dir--tramp-docker-hosts ()
          "Get a list of hosts from docker."
          (when (require 'docker-tramp nil t)
            (let ((hosts)
                  (docker-tramp-use-names t))
              (dolist (cand (docker-tramp--parse-running-containers))
                (let ((user (unless (string-empty-p (car cand))
                                (concat (car cand) "@")))
                      (host (car (cdr cand))))
                  (push (concat "/docker:" user host ":/") hosts)))
              hosts)))

        (defvar consult-dir--source-tramp-docker
          `(:name     "Docker"
            :narrow   ?d
            :category file
            :face     consult-file
            :history  file-name-history
            :items    ,#'consult-dir--tramp-docker-hosts)
          "Docker candidate source for `consult-dir'.")

        ;; (add-to-list 'consult-dir-sources 'consult-dir--source-tramp-ssh t)
        (add-to-list 'consult-dir-sources 'consult-dir--source-tramp-docker t)
      '';
    };

    # TODO: How is affe.el as a fuzzy-finder instead of consult-find and consult-ripgrep?
    consult = {
      enable = true;
      custom = { consult-project-function = "nil"; };
      extraPackages = [ pkgs.ripgrep ];
      general = [''
        (:keymaps '(override embark-general-map)
         "C-s" 'consult-line
         "C-x b" 'consult-buffer
         "C-c c" 'consult-recent-file

         ;; Override non-project default
         "C-c f" 'consult-find
         "C-c g" 'consult-ripgrep

         ;; Override project.el defaults.
         "C-x p f" (lambda () (interactive) (let ((consult-project-function #'consult--default-project-function)) (consult-find)))
         "C-x p g" (lambda () (interactive) (let ((consult-project-function #'consult--default-project-function)) (consult-ripgrep))))
      ''];
    };

    # TODO: Add the Citar package? How malleable and fitting is it in the whole Vertico, Embark, Consult, etc. environment?
    consult-notes = {
      enable = true;
      after = [ "consult" "denote" ];
    };

    wgrep = {
      enable = true;
      # TODO: Keybindings between wgrep and occur-mode are very different.
      # It might be good to uniformize them.
      # TODO: If general is included, other keybindings do not work anymore. Why is that?
      # general = [''
      #   (:keymaps 'grep-mode-map
      #    "M-RET" 'compilation-display-error)
      # ''];
    };

    marginalia = {
      enable = true;
      hook = [ "(after-init . marginalia-mode)" ];
    };

    # Embark replaces evil-nerd-commenter
    embark = {
      enable = true;
      hook = [ "(embark-collect-mode . hl-line-mode)" ];
      custom = {
        embark-confirm-act-all = "nil";
        embark-help-key = ''(kbd "?")'';
        embark-indicators =
          "'(embark--vertico-indicator embark-minimal-indicator embark-highlight-indicator embark-isearch-highlight-indicator)";
        # TODO: I am not sure what this does exactly.
        # I think this is a which-key replacement. I have to check, e.g. if I run C-c C-h or C-C ? this window pops-up.
        # prefix-help-command = "#'embark-prefix-help-command";
        # TODO: Set a separate binding for embark-become? C-SPC or so?
      };
      # TODO: These keymaps do not work in the terminal. Which keys do work in terminal mode?
      general = [''
        (:keymaps 'override
         "C-," #'embark-act
         "C-h b" #'embark-bindings)
        (:states '(insert normal visual)
         :keymaps 'vertico-map
         "C-b" #'embark-become
         "C-e" #'embark-export)
      ''];
    };

    # This comes by default with the Embark package.
    # embark-org = { enable = true; };

    embark-consult = {
      enable = true;
      after = [ "consult" "embark" ];
      hook = [ "(embark-collect-mode . consult-preview-at-point-mode)" ];
    };

    # TODO: My set-up including corfu seems to cause some annoying bugs with the cursor jumping
    # around in terminals. If I remove corfu, this issue is fixed. Do I need corfu?
    # corfu = {
    #   enable = true;
    #   hook = [ "(after-init . global-corfu-mode)" ];
    #   custom = {
    #     corfu-auto = "t";
    #     corfu-auto-prefix = "2";
    #     corfu-cycle = "t";
    #     corfu-auto-delay = "0.1";
    #   };
    # };

    prescient = {
      enable = true;
      config = ''
        (prescient-persist-mode 1)
      '';
    };
  };
}
