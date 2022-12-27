{
  flake.templates = {
    jupyter = {
      description = "Jupyter environment for data science";
      path = ./jupyter;
    };

    test-suites = {
      description = "Example Python project using a variety of test-suites";
      path = ./test-suites;
    };
  };
}
