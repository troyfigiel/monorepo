{ impermanence, config, lib, pkgs, ... }:

with lib;
let cfg = config.my.emacs;
in {
  options.my.emacs.enable = mkEnableOption "Emacs";

  config = mkIf cfg.enable (mkMerge [
    {
      programs.emacs = {
        enable = true;
        package = pkgs.tf-emacs;
      };

      # TODO: It works, but is not the right place for adding the package.
      # Once I move away from home-manager emacs-init, I will need to move this as well
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
        black
        python3
        nixfmt
        ispell
        texlive.combined.scheme-full
        nodePackages.prettier
        python3Packages.python-lsp-server
        python3Packages.flake8
      ];
    }

    (optionalAttrs impermanence {
      home.persistence."/nix/persist/${config.home.homeDirectory}".directories =
        [ ".emacs.d/eln-cache" ".emacs.d/var" ".emacs.d/etc" ];
    })
  ]);
}
