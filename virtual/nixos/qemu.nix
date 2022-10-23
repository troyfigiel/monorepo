{ nixosModules, ... }:

{
  imports = [ nixosModules.qemu-guest ./shared ];
  features.qemu-guest.enable = true;
}
