{
  users.users.root.openssh.authorizedKeys.keys =
    [ (builtins.readFile ../../assets/keys/troy.pub.ssh) ];
}
