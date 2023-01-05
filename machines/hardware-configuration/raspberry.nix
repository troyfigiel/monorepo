{ inputs, lib, ... }:

{
  imports = [ inputs.hardware.nixosModules.raspberry-pi-4 ];

  fileSystems."/" = {
    device = "/dev/disk/by-label/NIXOS_SD";
    fsType = "ext4";
  };

  fileSystems."/mnt/export" = {
    device = "/dev/disk/by-uuid/caeb2f11-a406-47df-8fc8-9e2a2a6902d3";
    fsType = "ext4";
  };

  fileSystems."/mnt/backup" = {
    device = "/dev/disk/by-uuid/a62b8436-0376-4f24-a45a-1e336b5f0928";
    fsType = "ext4";
  };

  swapDevices = [ ];

  nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";
  powerManagement.cpuFreqGovernor = lib.mkDefault "ondemand";
}
