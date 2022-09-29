{ pkgs, ...}:

{
  # TODO: This works, but need to check how to configure my printers declaratively in NixOS
  services.printing = {
    enable = true;
    drivers = [ pkgs.epson-escpr2 ];
  };
}
