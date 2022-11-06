{ writeShellApplication, nixos-rebuild }:

# TODO: This is a basic script. I can use Screen to do my health checks and run the upgrade on the target host.
writeShellApplication {
  name = "my-deployment";
  runtimeInputs = [ nixos-rebuild ];
  text = ''
    (( $# == 0 )) && host="$(cat /etc/hostname)" || host="$1"
    [[ "$host" == "$(cat /etc/hostname)" ]] && target_host="localhost" || target_host="$host"

    sudo nixos-rebuild switch \
         --flake ".#$host" \
         --target-host "$target_host"
  '';
}
