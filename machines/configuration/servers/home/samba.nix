{
  # Only expose the smb mount to the client
  fileSystems."/export/smb" = {
    device = "/mnt/export/smb";
    options = [ "bind" ];
  };

  services.samba = {
    enable = true;
    openFirewall = true;
    extraConfig = ''
      map to guest = bad user
      hosts allow = 192.168.178.26 192.168.178.41 192.168.178.42
    '';
    shares.smb = {
      path = "/export/smb";
      browseable = "yes";
      "read only" = "no";
      "guest ok" = "yes";
      "create mask" = "0644";
      "directory mask" = "0755";
      "force user" = "samba";
      "force group" = "samba";
    };
  };

  users = {
    groups.samba = { };
    users.samba = {
      isNormalUser = true;
      createHome = false;
      group = "samba";
    };
  };
}
