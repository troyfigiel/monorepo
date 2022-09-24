let sshPath = "/nix/persist/etc/ssh";
in {
  services.openssh = {
    enable = true;
    passwordAuthentication = false;
    permitRootLogin = "yes";

    hostKeys = [
      {
        bits = 4096;
        path = "${sshPath}/ssh_host_rsa_key";
        type = "rsa";
      }
      {
        path = "${sshPath}/ssh_host_ed25519_key";
        type = "ed25519";
      }
    ];
  };

  sops = {
    defaultSopsFile = ./secrets.yaml;
    gnupg.sshKeyPaths = [ "${sshPath}/ssh_host_rsa_key" ];
    age.sshKeyPaths = [ ];

    # TODO: It makes more sense to store the secrets with the nix files that use them.
    secrets = {
      troy-password = { neededForUsers = true; };
      rpi-mnt-password = { };
      rpi-backup-password = { };
      ssh-restic = { };
    };
  };
}

