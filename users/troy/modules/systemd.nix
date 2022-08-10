{ pkgs, ... }:

{
  systemd.user.services = {
    clone-emacs-config = {
      Unit = {
        Description = "Service that clones my Emacs config to .emacs.d";
      };

      Service = {
        Type = "oneshot";
        ExecStart = "${pkgs.git}/bin/git clone git@gitlab.com:troy.figiel/emacs.git /home/troy/.emacs.d";
      };
    };

    clone-notes = {
      Unit = {
        Description = "Service that clones my Zettelkasten notes";
      };

      Service = {
        Type = "oneshot";
        ExecStart = "${pkgs.git}/bin/git clone git@gitlab.com:troy.figiel/zettelkasten.git /home/troy/zettelkasten";
      };
    };
  };
}
