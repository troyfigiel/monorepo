{
  # Only expose the nfs mount to the client
  fileSystems."/export/nfs" = {
    device = "/mnt/export/nfs";
    options = [ "bind" ];
  };

  services.nfs.server = {
    enable = true;
    exports = ''
      /export/nfs 192.168.178.26(rw,sync,no_subtree_check)
    '';
  };

  users.users.troy = {
    isNormalUser = true;
    createHome = false;
    uid = 1000;
  };

  networking.firewall.allowedTCPPorts = [ 2049 ];
}
