{ availableKernels, ... }:

availableKernels.python {
  projectDir = ./.;
  displayName = "Python with packages";
  name = "python-with-packages";
}
