{
  environment.persistence."/nix/persist" = {
    hideMounts = true;
    directories = [ "/etc/nixos" "/etc/ssh" "/var/log" ];

    files = [ "/etc/machine-id" ];

    users.root = {
      home = "/root";
      directories = [ ".gnupg" ];
    };

    users.troy = {
      directories = [ "Documents" "Downloads" "Media" "Projects" ];
    };
  };
}
