{ config, ... }:

{
  # This is actually already set by programs.steam.enable = true;
  hardware.opengl = {
    enable = true;
    driSupport32Bit = true;
  };

  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;
}
