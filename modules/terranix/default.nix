{
  flake.terranixModules = {
    machines = import ./machines;
    records = import ./records;
  };
}
