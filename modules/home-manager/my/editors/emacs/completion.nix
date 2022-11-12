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

    consult-dir = {
      enable = true;
      hook = [ "(after-init . recentf-mode)" ];
      after = [ "consult" ];
      # I can use Embark for any other action, e.g. jumping to a file, ripgrep or whatever other action I want to take.
      general = [''
        (:keymaps 'override
         "C-x C-d" #'consult-dir)
      ''];
      config = ''
        (run-at-time nil (* 5 60) 'recentf-save-list)
      '';
    };
    # TODO: This requires docker-tramp to be installed. How to make the dependency explicit?
    # TODO: To get the same for SSH, I need to create a .ssh/config file containing my hosts.
    #   config = ''
    #     (defun consult-dir--tramp-docker-hosts ()
    #       "Get a list of hosts from docker."
    #       (when (require 'docker-tramp nil t)
    #         (let ((hosts)
    #               (docker-tramp-use-names t))
    #           (dolist (cand (docker-tramp--parse-running-containers))
    #             (let ((user (unless (string-empty-p (car cand))
    #                             (concat (car cand) "@")))
    #                   (host (car (cdr cand))))
    #               (push (concat "/docker:" user host ":/") hosts)))
    #           hosts)))

    #     (defvar consult-dir--source-tramp-docker
    #       `(:name     "Docker"
    #         :narrow   ?d
    #         :category file
    #         :face     consult-file
    #         :history  file-name-history
    #         :items    ,#'consult-dir--tramp-docker-hosts)
    #       "Docker candidate source for `consult-dir'.")

    #     (add-to-list 'consult-dir-sources 'consult-dir--source-tramp-ssh t)
    #     (add-to-list 'consult-dir-sources 'consult-dir--source-tramp-docker t)
    #   '';

    consult = {
      enable = true;
      custom = { consult-project-function = "nil"; };
      extraPackages = [ pkgs.ripgrep ];
      # TODO: consult-find and consult-ripgrep default to setting the project if I am in a project. This can be prevented by using the universal modifier, but that is a bit cumbersome. I should be able to use simulated keypresses to e.g. bind C-x C-f to the modified consult-find.
      # TODO: Marks are useful, but how do I remove them?
      general = [''
        (:keymaps '(override embark-general-map)
         "C-s" 'consult-line
         "C-x b" 'consult-buffer

         ;; Override non-project default
         "C-c f" 'consult-find
         "C-c g" 'consult-ripgrep

         ;; Override project.el defaults.
         "C-x p f" (lambda () (interactive) (let ((consult-project-function #'consult--default-project-function)) (consult-find)))
         "C-x p g" (lambda () (interactive) (let ((consult-project-function #'consult--default-project-function)) (consult-ripgrep))))
      ''];
    };

    # consult-notes = {
    #   enable = true;
    #   after = [ "consult" "denote" ];
    # };

    wgrep = {
      enable = true;
      general = [''
        (:states 'normal
         :keymaps 'grep-mode-map
         "i" 'wgrep-change-to-wgrep-mode)
        ;; For consistency between wgrep and occur mode I change the occur-mode keybinding.
        (:states 'normal
         :keymaps '(occur-mode-map occur-edit-mode-map)
         "g o" 'occur-mode-display-occurrence)
      ''];
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

    corfu = {
      enable = true;
      hook = [ "(after-init . global-corfu-mode)" ];
      custom = {
        corfu-auto = "t";
        corfu-auto-prefix = "2";
        corfu-cycle = "t";
        corfu-auto-delay = "0.1";
      };
    };

    prescient = {
      enable = true;
      hook = [ "(after-init . prescient-persist-mode)" ];
    };
  };
}
