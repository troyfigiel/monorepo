{ impermanence, pkgs, ... }:

let sshPath = if impermanence then "/nix/persist/etc/ssh" else "/etc/ssh";
in {
  sops = {
    gnupg.sshKeyPaths = [ "${sshPath}/ssh_host_rsa_key" ];
    age.sshKeyPaths = [ ];
  };

  environment.systemPackages = [ pkgs.git pkgs.vim ];

  nix = {
    package = pkgs.nixVersions.stable;
    settings = {
      # TODO: The minio-client itself is also great for connecting to a variety of S3 compatible APIs.
      # Until my own binary cache is set up, let's turn it off.
      # substituters = [ "http://192.168.178.37:10106/nix-binary-cache/" ];
      # trusted-public-keys =
      #  [ "minio.local-1:ZTYgVFeAYCoDqu0HppKRQRy54es8EZ5LVAmZQJO/VDA=" ];
      # trusted-users = [ "troy" ];
      auto-optimise-store = true;
    };

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };

    extraOptions = "experimental-features = nix-command flakes";
  };
}
