{ config, ... }:

{
  resource.local_file.nix_input = {
    filename = "\${path.module}/../machines/network.nix";
    content = ''
      {
        cloud-server.address = "''${vultr_instance.cloud-server.main_ip}";
        laptop.address = "laptop.fritz.box";
        raspberry.address = "raspberrypi.fritz.box";
      }
    '';
    file_permission = "0644";
  };
}
