{ pkgs, ... }:

{
  programs.emacs.init.usePackage = {
    vertico = {
      enable = true;
      hook = [ "(after-init . vertico-mode)" ];
      custom = { vertico-cycle = "t"; };
      general = [''
        (:states 'normal
         :keymaps 'vertico-map
         "j" #'vertico-next
         "k" #'vertico-previous
         "q" #'abort-minibuffers
         "RET" #'vertico-exit)
      ''];
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

    # TODO: I do not get this yet. Need to figure out how this works.
    consult-dir = {
      enable = true;
      # TODO: What does recentf do exactly?
      hook = [ "(after-init . recentf-mode)" ];
      after = [ "consult" ];
      # TODO: C-x C-j a replacement for dired-jump?
      general = [''
        (:keymaps 'override
         "C-x C-d" #'consult-dir)
        (:states '(insert motion visual)
         :keymaps 'vertico-map
         "C-x C-d" #'consult-dir
         "C-x C-j" #'consult-dir-jump-file)
      ''];
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
    };

    consult = {
      enable = true;
      extraPackages = [ pkgs.ripgrep ];
      # TODO: consult-find and consult-ripgrep default to setting the project if I am in a project. This can be prevented by using the universal modifier, but that is a bit cumbersome. I should be able to use simulated keypresses to e.g. bind C-x C-f to the modified consult-find.
      general = [''
        (:keymaps 'override
         "C-s" 'consult-line
         "C-x b" 'consult-buffer

         ;; Override project.el defaults.
         "C-x p f" 'consult-find
         "C-x p g" 'consult-ripgrep)
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
      custom = {
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
