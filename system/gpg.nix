{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    gnupg
    pinentry
    pass
  ];

  # Allows communication with smartcards.
  services.pcscd.enable = true;

  programs = {
    ssh.startAgent = false;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
      pinentryFlavor = "gtk2";
    };
  };

  services.gnome.gnome-keyring.enable = pkgs.lib.mkForce false;
}
