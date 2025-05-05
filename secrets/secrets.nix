let
  # SYSTEMS
  heimdall = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBs+qYjpeAEHPFUQeatNkhKbXz8+A1VAl21jgifDYJK8";
  loki = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIF+xpWCoBEO/pzAwS1ZZEsiLSarvSVkdxQEo49xma2PV";

  # USERS
  root = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBJLduAXHWJiglmfRfkBGKffzVWkJP6porxIzw6+Zz3W crony@cronyakatsuki.xyz";

  users = [
    root
  ];
  systems = [heimdall loki];
in {
  "traefik.age".publicKeys = systems ++ users;
  "wg-heimdall.age".publicKeys = systems ++ users;
  "wg-desktop.age".publicKeys = systems ++ users;
}
