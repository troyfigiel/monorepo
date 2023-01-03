{ impermanence, ... }:

let sshPath = if impermanence then "/nix/persist/etc/ssh" else "/etc/ssh";
in {
  imports = [ ./all.nix ];

  services.openssh = {
    enable = true;
    passwordAuthentication = false;

    hostKeys = [{
      type = "rsa";
      bits = 4096;
      path = "${sshPath}/ssh_host_rsa_key";
    }];
  };

  users.users.root.openssh.authorizedKeys.keys =
    [ (builtins.readFile ../assets/admin-keys/troy.pub.ssh) ];
}
