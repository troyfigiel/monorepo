{
  services.qemuGuest.enable = true;
  # TODO: For some reason it does not seem to rescale the screen for UTM on MacOS. Why?
  services.spice-vdagentd.enable = true;
}
