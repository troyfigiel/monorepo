{ config, lib, pkgs, ... }:

with lib;
let cfg = config.roles.gpg;
in {
  options.roles.gpg.enable = mkEnableOption "GPG";

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ gnupg pinentry ];

    # TODO: Allows communication with smartcards. Do I need this still?
    services.pcscd.enable = true;

    # TODO: Can I move this to the home config like I did with the gpg-agent?
    programs.ssh.startAgent = false;

    # TODO: Do I need this?
    services.gnome.gnome-keyring.enable = pkgs.lib.mkForce false;
  };
}

