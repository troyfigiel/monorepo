{
  environment.persistence."/nix/persist" = {
    hideMounts = true;
    directories = [
      "/etc/NetworkManager/system-connections"
      "/etc/nixos"
      "/etc/ssh"
      "/var/log"
    ];

    files = [ "/etc/machine-id" ];

    users.root = {
      home = "/root";
      directories = [ ".gnupg" ];
    };

    users.troy = {
      directories = [
        # Signal stores its data in the .config directory.
        # See: https://github.com/signalapp/Signal-Desktop/issues/4975
        ".config/Signal"
        ".config/whatsapp-for-linux"
        ".cache/mozilla"
        ".mozilla"
        ".wallpapers"
        ".local/share/atuin"
        ".ssh/known_hosts"
        ".vscode"
        "Documents"
        "Downloads"
        "Media"
        "Projects"
      ];
    };
  };
}
