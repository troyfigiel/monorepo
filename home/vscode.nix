{ pkgs, ... }:

{
  programs.vscode = {
    enable = true;
    # There currently seems to be a bug preventing me from putting this to true
    # https://github.com/nix-community/home-manager/issues/2798
    mutableExtensionsDir = false;
    #package = pkgs.vscode;
    extensions = with pkgs.vscode-extensions; [
      _4ops.terraform
      #aaron-bond.better-comments
      adpyke.codesnap
      bbenoist.nix
      #brunoventura.sqltools-athena-driver
      bungcip.better-toml
      christian-kohler.path-intellisense
      #donjayamanne.python-environment-manager
      eamodio.gitlens
      #innoverio.vscode-dbt-power-user
      #iterative.dvc
      #kevinglasson.cornflakes-linter
      #KevinRose.vsc-python-indent
      #kj.sqltools-driver-redshift
      mechatroner.rainbow-csv
      ms-azuretools.vscode-docker
      ms-python.python
      ms-python.vscode-pylance
      ms-toolsai.jupyter
      #ms-toolsai.jupyter-keymap
      ms-toolsai.jupyter-renderers
      #ms-vscode-remote.remote-containers
      ms-vscode-remote.remote-ssh
      #ms-vscode-remote.remote-ssh-edit
      #ms-vscode-remote.remote-wsl
      #ms-vscode-remote.vscode-remote-extensionpack
      #mtxr.sqltools
      #mtxr.sqltools-driver-pg
      #mtxr.sqltools-driver-sqlite
      njpwerner.autodocstring
      oderwat.indent-rainbow
      redhat.vscode-yaml
      #samuelcolvin.jinjahtml
      vscodevim.vim      
    ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [

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
