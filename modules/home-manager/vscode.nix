{ config, lib, pkgs, ... }:

with lib;
let cfg = config.features.vscode;
in {
  # TODO: Split up the vscode based on "package type"?
  # For example, I might not need Terraform in every case.
  options.features.vscode = {
    enable = mkEnableOption "vscode";

    hugo = mkOption {
      default = false;
      type = types.bool;
    };

    lisp = mkOption {
      default = false;
      type = types.bool;
    };
  };

  config = mkIf cfg.enable {
    programs.vscode = {
      enable = true;
      mutableExtensionsDir = false;
      extensions = let
        vscode-extensions = with pkgs.vscode-extensions; [
          _4ops.terraform
          bbenoist.nix
          brettm12345.nixfmt-vscode
          bungcip.better-toml
          christian-kohler.path-intellisense
          eamodio.gitlens
          humao.rest-client
          mattn.lisp
          mechatroner.rainbow-csv
          ms-azuretools.vscode-docker
          # TODO: This is not supported on aarch64-linux
          ms-python.python
          ms-python.vscode-pylance
          ms-vscode-remote.remote-ssh
          ms-toolsai.jupyter
          ms-toolsai.jupyter-renderers
          njpwerner.autodocstring
          oderwat.indent-rainbow
          redhat.vscode-yaml
          vscodevim.vim
        ];
        vscode-marketplace = with pkgs.vscode-marketplace.vscode; [
          aaron-bond.better-comments
          budparr.language-hugo-vscode
          innoverio.vscode-dbt-power-user
          iterative.dvc
          kevinglasson.cornflakes-linter
          kevinrose.vsc-python-indent
          ms-toolsai.jupyter-keymap
          ms-vscode.makefile-tools
          ms-vscode-remote.remote-containers
          samuelcolvin.jinjahtml
          sir2b.lispbeautifier
        ];
      in vscode-extensions ++ vscode-marketplace;
      userSettings = {
        "diffEditor.renderSideBySide" = false;
        "dvc.doNotShowWalkthroughAfterInstall" = true;
        "editor.codeActionsOnSave" = {
          "source.fixAll" = true;
          "source.organizeImports" = true;
        };
        "editor.detectIndentation" = false;
        "editor.formatOnSave" = true;
        "editor.formatOnSaveMode" = "file";
        "explorer.confirmDelete" = false;
        "explorer.confirmDragAndDrop" = false;
        "files.autoSave" = "afterDelay";
        "git.ignoreMissingGitWarning" = false;
        "gitlens.codeLens.authors.enabled" = false;
        "gitlens.codeLens.enabled" = false;
        "gitlens.currentLine.enabled" = false;
        "gitlens.showWelcomeOnInstall" = false;
        "gitlens.showWhatsNewAfterUpgrades" = false;
        # The keyCode dispatch is needed because I make my
        # caps lock into a second escape key.
        # Unfortunately, this also messes up a whole bunch of
        # other keys... I still need to figure out how this works.
        # Maybe leave it as is and use Ctrl+c for returning to normal mode?
        # VSCode keybindings are Ctrl heavy by default anyway.
        # "keyboard.dispatch" = "keyCode";
        "python.analysis.typeCheckingMode" = "basic";
        "python.formatting.provider" = "black";
        "python.linting.enabled" = true;
        "python.terminal.activateEnvironment" = false;
        "python.testing.pytestEnabled" = true;
        "redhat.telemetry.enabled" = false;
        "remote.containers.defaultExtensions" = [
          "4ops.terraform"
          "bbenoist.nix"
          "bungcip.better-toml"
          "christian-kohler.path-intellisense"
          "eamodio.gitlens"
          "mechatroner.rainbow-csv"
          "ms-python.python"
          "ms-python.vscode-pylance"
          "ms-toolsai.jupyter"
          "ms-toolsai.jupyter-keymap"
          "ms-toolsai.jupyter-renderers"
          "njpwerner.autodocstring"
          "oderwat.indent-rainbow"
          "redhat.vscode-yaml"
          "samuelcolvin.jinjahtml"
          "vscodevim.vim"
        ];
        "telemetry.telemetryLevel" = "off";
        "terminal.integrated.enableMultiLinEPasteWarning" = false;
        "terminal.integrated.enablePersistentSessions" = false;
        "vim.handleKeys" = {
          "<C-d>" = true;
          "<C-f>" = false;
          "<C-h>" = false;
          "<C-s>" = false;
          "<C-w>" = false;
          "<C-z>" = false;
        };
        "vim.smartRelativeLine" = true;
        "vim.sneak" = true;
        "vim.sneakReplacesF" = true;
        "vim.useSystemClipboard" = true;
        "workbench.startupEditor" = "none";
      };
    };

    home.packages = with pkgs; [ nixfmt gnumake terraform ];
  };
}
