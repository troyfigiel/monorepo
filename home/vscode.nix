{ pkgs, ... }:

{
  programs.vscode = {
    enable = true;
    # This is the default, but if all extensions are properly
    # packaged, I can switch this to false.
    mutableExtensionsDir = true;
    extensions = with pkgs.vscode-extensions;
      [
        _4ops.terraform
        #TO INSTALL: aaron-bond.better-comments
        bbenoist.nix
        brettm12345.nixfmt-vscode
        bungcip.better-toml
        christian-kohler.path-intellisense
        eamodio.gitlens
        humao.rest-client
        #TO INSTALL: innoverio.vscode-dbt-power-user
        #TO INSTALL: iterative.dvc
        #TO INSTALL: kevinglasson.cornflakes-linter
        #TO INSTALL: KevinRose.vsc-python-indent
        mechatroner.rainbow-csv
        ms-azuretools.vscode-docker
        ms-python.python
        ms-python.vscode-pylance
        ms-toolsai.jupyter
        #TO INSTALL: ms-toolsai.jupyter-keymap
        ms-toolsai.jupyter-renderers
        #TO INSTALL: ms-vscode-remote.remote-containers
        ms-vscode-remote.remote-ssh
        #TO INSTALL: ms-vscode-remote.remote-ssh-edit
        njpwerner.autodocstring
        oderwat.indent-rainbow
        redhat.vscode-yaml
        #TO INSTALL: samuelcolvin.jinjahtml
        vscodevim.vim
      ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
        # I have not been able to get this to work yet, unfortunately.
        #{
        #  name = "sqltools";
        #  publisher = "mtxr";
        #  version = "";
        #  sha256 = "";
        #}
      ];
    userSettings = {
      "diffEditor.renderSideBySide" = false;
      "dvc.doNotShowWalkthroughAfterInstall" = true;
      "editor.codeActionsOnSave" = {
        "source.fixAll" = true;
        "source.organizeImports" = true;
      };
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
      "python.analysis.typeCheckingMode" = "basic";
      "python.formatting.provider" = "black";
      "python.linting.enabled" = true;
      "python.terminal.activateEnvironment" = false;
      "python.testing.pytestEnabled" = true;
      "redhat.telemetry.enabled" = false;
      # I could probably install all extensions automatically using
      # a variable instead of duplicating code.
      "remote.containers.defaultExtensions" = [
        "4ops.terraform"
        "bbenoist.nix"
        "bungcip.better-toml"
        "christian-kohler.path-intellisense"
        "eamodio.gitlens"
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
      "terminal.integrated.enablePersistentSessions" = false;
      "vim.handleKeys" = {
        "<C-d>" = true;
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
}
