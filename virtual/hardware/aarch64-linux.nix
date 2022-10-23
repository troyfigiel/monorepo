{ lib, modulesPath, ... }:

{
  imports = [ (modulesPath + "/profiles/qemu-guest.nix") ./shared.nix ];

  boot.initrd = {
    availableKernelModules =
      [ "xhci_pci" "virtio_pci" "usbhid" "usb_storage" "sr_mod" ];
    kernelModules = [ ];
  };

  networking.useDHCP = lib.mkDefault true;
  nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";
}
