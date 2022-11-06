{ writeShellApplication, nixos-rebuild }:

# TODO: This is a basic script. I can use Screen to do my health checks and run the upgrade on the target host.
writeShellApplication {
  name = "my-deployment";
  runtimeInputs = [ nixos-rebuild ];
  # TODO: Exchange if statements with a case statement
  # TODO: Add boolean parameter deploy to parameters.nix which is true if the host should be included in the default deployment run
  text = ''
    (( $# == 0 )) && host="$(cat /etc/hostname)" || host="$1"
    [[ "$host" == "$(cat /etc/hostname)" ]] && target_host="localhost" || target_host="$host"

    sudo nixos-rebuild switch \
         --flake ".#$host" \
         --target-host "$target_host"
  '';
}
