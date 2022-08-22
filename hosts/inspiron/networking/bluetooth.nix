{
  services.blueman.enable = true;

  # Trusting a bluetooth device is needed to automatically connect.
  environment.persistence."/nix/persist".directories = [ "/var/lib/bluetooth" ];
}
