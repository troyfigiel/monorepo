{
  services.gitea = {
    enable = true;
    appName = "Troy's Gitea server";
    domain = "192.168.178.31";
    rootUrl = "http://192.168.178.31:3000/";
    stateDir = "/mnt/export/gitea";
    dump.enable = true;
  };

  networking.firewall.allowedTCPPorts = [ 3000 ];
}
