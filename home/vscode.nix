{ pkgs, ... }:

{
  programs.vscode = {
    enable = true;
    # This is the default, but if all extensions are properly
    # packaged, I can switch this to false.
    mutableExtensionsDir = true;
    extensions = with pkgs.vscode-extensions; [
      _4ops.terraform
      #TO INSTALL: aaron-bond.better-comments
      adpyke.codesnap
      bbenoist.nix
      #TO INSTALL: brunoventura.sqltools-athena-driver
      bungcip.better-toml
      christian-kohler.path-intellisense
      #donjayamanne.python-environment-manager
      eamodio.gitlens
      #TO INSTALL: innoverio.vscode-dbt-power-user
      #TO INSTALL: iterative.dvc
      #TO INSTALL: kevinglasson.cornflakes-linter
      #TO INSTALL: KevinRose.vsc-python-indent
      #TO INSTALL: kj.sqltools-driver-redshift
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
      #TO INSTALL: ms-vscode-remote.remote-wsl
      #TO INSTALL: ms-vscode-remote.vscode-remote-extensionpack
      #TO INSTALL: mtxr.sqltools
      #TO INSTALL: mtxr.sqltools-driver-pg
      #TO INSTALL: mtxr.sqltools-driver-sqlite
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
      "telemetry.telemetryLevel" = "off";
      "files.autoSave" = "afterDelay";
      "dvc.doNotShowWalkthroughAfterInstall" = true;
      "editor.formatOnSaveMode" = "file";
      "editor.formatOnSave" = true;
      "editor.codeActionsOnSave" = {
          "source.fixAll" = true;
          "source.organizeImports" = true;
      };
      "python.analysis.typeCheckingMode" = "basic";
      "python.linting.enabled" = true;
      "python.formatting.provider" = "black";
      "python.testing.pytestEnabled" = true;
      "vim.sneak" = true;
      "vim.sneakReplacesF" = true;
      "vim.smartRelativeLine" = true;
      "vim.useSystemClipboard" = true;
      "workbench.startupEditor" = "none";
      "diffEditor.renderSideBySide" = false;
      "gitlens.showWelcomeOnInstall" = false;
      "gitlens.showWhatsNewAfterUpgrades" = false;
      "gitlens.currentLine.enabled" = false;
      "gitlens.codeLens.authors.enabled" = false;
      "gitlens.codeLens.enabled" = false;
      "explorer.confirmDragAndDrop" = false;
      "explorer.confirmDelete" = false;
      "terminal.integrated.enablePersistentSessions" = false;
      "vim.handleKeys" = {
          "<C-w>" = false;
          "<C-d>" = true;
          "<C-s>" = false;
          "<C-z>" = false;
      };
      "python.terminal.activateEnvironment" = false;
    };
  };
}
