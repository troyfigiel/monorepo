{ pkgs, ... }: 

{
  environment.systemPackages = with pkgs; [ gnupg pinentry ];
  # TODO: Allows communication with smartcards. Do I need this still?
  services.pcscd.enable = true;
  # TODO: Can I move this to the home config like I did with the gpg-agent?
  programs.ssh.startAgent = false;
  services.gnome.gnome-keyring.enable = pkgs.lib.mkForce false;
}

