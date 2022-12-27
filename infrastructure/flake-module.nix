{
  perSystem = { pkgs, ... }: {
    apps.infrastructure = {
      type = "app";
      program = pkgs.writeShellApplication {
        name = "monorepo-infrastructure";
        runtimeInputs = with pkgs; [ coreutils execline.bin terraform ];
        text = ''
          cd infrastructure || exit 1
          terraform init
          terraform apply
          terraform output -json > outputs.json
        '';
      };
    };
  };
}
