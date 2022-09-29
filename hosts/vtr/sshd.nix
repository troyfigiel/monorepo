let sshPath = "/etc/ssh";
in {
  services.openssh = {
    enable = true;
    permitRootLogin = "yes";
    passwordAuthentication = false;

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
