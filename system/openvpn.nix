{
  services.openvpn = {
    servers = {
      workVPN = {
        config = '' config /root/nixos/openvpn/workVPN.conf '';
        autoStart = false;
        updateResolvConf = true;
      };
    };
  };
}