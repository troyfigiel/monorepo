{
  flake.terranixModules = {
    machines = import ./my/machines;
    records = import ./my/dns;
  };
}
