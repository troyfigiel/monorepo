{ pkgs, ... }:

# It is not enough to import my private key into gpg!
# To use ssh, I also need to add the authentication key to ~/.gnupg/sshcontrol
{
  environment.systemPackages = with pkgs; [ gnupg pinentry ];

  # Allows communication with smartcards. Do I need this still?
  services.pcscd.enable = true;

  # Can I move this to the home config like I did with the gpg-agent?
  programs.ssh.startAgent = false;
  services.gnome.gnome-keyring.enable = pkgs.lib.mkForce false;
}
