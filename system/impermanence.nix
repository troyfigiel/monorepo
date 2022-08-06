{
  # TODO: Add a bunch of directories and files.
  # TODO: Create a tmpfs partition.
  environment.persistence."/nix/state" = {
    hideMounts = true;
    users.troy = { files = [ "impermanence-test-file" ]; };
  };
}
