{
  # TODO: The directories that are required to be persisted should be moved to the appropriate modules.
  # Here it is too unclear why I am persisting certain directories or files.
  environment.persistence."/nix/persist" = {
    hideMounts = true;
    directories = [
      "/etc/NetworkManager/system-connections"
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
      # TODO: Do I really need this?
      "/var/lib/systemd/coredump"
    ];

    files = [
      "/etc/machine-id"
      "/etc/NetworkManager/passwd-file"
      # TODO: We actually do not need this to be symlinked. We are pointing directly at /nix/persist anyway.
      # {
      #   file = "/etc/ssh/ssh_host_rsa_key";
      #   parentDirectory = { mode = "0700"; };
      # }
    ];

    users.root = {
      home = "/root";
      directories = [ ".cert" ".gnupg" ];
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
        ".local/share/Steam"
        # TODO: I am not sure what this is, but it got pulled in with Steam I believe.
        ".local/share/vulkan"
        ".local/share/atuin"
        ".local/share/password-store"
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
