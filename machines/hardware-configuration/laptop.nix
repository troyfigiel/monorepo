{ config, lib, modulesPath, pkgs, ... }:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  fileSystems = {
    "/" = {
      device = "none";
      fsType = "tmpfs";
      options = [ "defaults" "size=8G" "mode=755" ];
    };

    "/boot/efi" = {
      device = "/dev/disk/by-uuid/6E9B-C916";
      fsType = "vfat";
    };

    "/nix" = {
      device = "/dev/disk/by-uuid/47cda452-dc47-4654-ba46-e46035d7a672";
      fsType = "ext4";
    };

    "/mnt/nfs" = {
      device = "192.168.178.31:/export/nfs";
      fsType = "nfs";
      options = [ "x-systemd.automount" "noauto" ];
    };

    "/mnt/smb" = {
      device = "//192.168.178.31/smb";
      fsType = "cifs";
      options = [ "x-systemd.automount" "noauto" "uid=1000" "gid=100" ];
    };
  };

  swapDevices = [ ];

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      efi.efiSysMountPoint = "/boot/efi";
    };

    initrd = {
      availableKernelModules =
        [ "xhci_pci" "ahci" "nvme" "usb_storage" "sd_mod" ];
      kernelModules = [ ];
    };

    kernelPackages = pkgs.linuxPackages_latest;
    kernelModules = [ "kvm-intel" ];
    extraModulePackages = [ ];
  };

  hardware = {
    cpu.intel.updateMicrocode =
      lib.mkDefault config.hardware.enableRedistributableFirmware;

    nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;
    opengl = {
      enable = true;
      driSupport32Bit = true;
    };

    pulseaudio.enable = false;

    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
  };

  networking.useDHCP = lib.mkDefault true;
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
}
