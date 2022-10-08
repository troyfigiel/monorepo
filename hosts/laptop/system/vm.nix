{ pkgs, ... }:

{
  virtualisation.libvirtd.enable = true;
  environment = {
    systemPackages = with pkgs; [ qemu virt-manager ];
    persistence."/nix/persist".directories = [ "/var/lib/libvirt" ];
  };
}
