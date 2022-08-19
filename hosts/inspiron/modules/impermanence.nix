{
  # TODO: The directories that are required to be persisted should be moved to the appropriate modules.
  # Here it is too unclear why I am persisting certain directories or files.
  environment.persistence."/nix/persist" = {
    hideMounts = true;
    directories = [
      # I might need to change the permissions to 755
      {
        directory = "/etc/NetworkManager";
        mode = "0755";
      }
      # "/etc/nixos"
      "/var/log"
      # This gets rid of the local sysadmin lecture message.
      # TODO: This could be symlinked in place, because it only requires a file with username to exist.
      {
        directory = "/var/db/sudo/lectured";
        mode = "0700";
      }
      # Trusting a bluetooth device is needed to automatically connect.
      "/var/lib/bluetooth"
      "/var/lib/docker"
    ];

    files = [
      "/etc/machine-id"
      # TODO: We actually do not need this to be symlinked or bound. We are pointing directly at /nix/persist anyway.
      # {
      #   file = "/etc/ssh/ssh_host_rsa_key";
      #   parentDirectory = { mode = "0700"; };
      # }
    ];

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
        ".cache/whatsapp-for-linux"
        ".cache/mozilla"
        ".mozilla"
        ".wallpapers"
        ".steam"
        ".cert"
        ".local/share/Steam"
        # TODO: I am not sure what this is, but it got pulled in with Steam I believe.
        ".local/share/vulkan"
        ".local/share/atuin"
        ".local/share/password-store"
        ".local/share/DBeaverData"
        ".local/share/direnv/allow"
        ".vscode"
        "Documents"
        "Downloads"
        "Media"
        "Projects"
      ];

      files = [ ".ssh/known_hosts" ];
    };
  };
}
