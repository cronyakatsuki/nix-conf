let
  # SYSTEMS
  heimdall = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBs+qYjpeAEHPFUQeatNkhKbXz8+A1VAl21jgifDYJK8";

  # USERS
  root = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBJLduAXHWJiglmfRfkBGKffzVWkJP6porxIzw6+Zz3W crony@cronyakatsuki.xyz";

  users = [
    root
  ];
  systems = [heimdall];
in {
  "traefik.age".publicKeys = systems ++ users;
}
