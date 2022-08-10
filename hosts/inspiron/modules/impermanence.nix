{
  # TODO: Add a bunch of directories and files.
  # TODO: Create a tmpfs partition.
  # This does not work nicely on a normal partition, because the bind
  # mount leaves behind files that on the next boot prevent impermanence
  # from setting up bind mounts again.
  # environment.persistence."/nix/state" = {
  #   hideMounts = true;
  #   users.troy = { files = [ "impermanence-test-file" ]; };
  # };
}
