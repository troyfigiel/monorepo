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
}
