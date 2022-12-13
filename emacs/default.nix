{ impermanence, config, lib, pkgs, ... }:

with lib;
let cfg = config.my.emacs;
in {
  options.my.emacs.enable = mkEnableOption "Emacs";

  config = mkIf cfg.enable (mkMerge [
    {
      programs.emacs = {
        enable = true;
        package = pkgs.emacsWithPackagesFromUsePackage {
          config = ./init.el;
          defaultInitFile = true;
          package = pkgs.emacsGit;
          alwaysEnsure = false;
        };
      };

      # TODO: It works, but is not the right place for adding the package.
      # Once I move away from home-manager emacs-init, I will need to move this as well.
      home.packages = with pkgs; [
        python3Packages.jupytext
        imagemagick
        exiftool
        rsync
        emacs-all-the-icons-fonts
        inconsolata
        libvterm
        dtach
        ripgrep
        ispell
        tree-sitter
        sqls
        terraform-ls
        black
        python3
        nixfmt
        rnix-lsp
        ispell
        texlive.combined.scheme-full
        nodePackages.prettier
        python3Packages.python-lsp-server
        # python3Packages.pylsp-rope
        # TODO: pylsp-mypy is broken in the current update.
        # python3Packages.pylsp-mypy
        python3Packages.flake8
        # docker-langserver
        tf-exif

      ];
    }

    (optionalAttrs impermanence {
      home.persistence."/nix/persist/${config.home.homeDirectory}".directories =
        [ ".emacs.d/eln-cache" ".emacs.d/var" ".emacs.d/etc" ];
    })
  ]);
}
