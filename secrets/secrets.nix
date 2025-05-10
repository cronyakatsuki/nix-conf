let
  # SYSTEMS
  heimdall = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBs+qYjpeAEHPFUQeatNkhKbXz8+A1VAl21jgifDYJK8";
  loki = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIF+xpWCoBEO/pzAwS1ZZEsiLSarvSVkdxQEo49xma2PV";
  baldur = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOvZ7Z8GS4+1+9D6u/BDit4Eij5Ubbii2dzJ/+ecT8iR";
  bragi = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBKMV2vqlDvIkUefl5oEuVjVtjgFLEXyDKX2LWhVQsWT";
  thor = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHZGQLUhyLwmkTYhSccqO8umQJN0QHk6YaD863x7lcGv";

  # USERS
  root = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBJLduAXHWJiglmfRfkBGKffzVWkJP6porxIzw6+Zz3W crony@cronyakatsuki.xyz";

  users = [
    root
  ];
  systems = [heimdall loki baldur bragi thor];
in {
  "traefik.age".publicKeys = systems ++ users;
  "wg-heimdall.age".publicKeys = systems ++ users;
  "wg-desktop.age".publicKeys = systems ++ users;
  "rclone.age".publicKeys = systems ++ users;
  "navidrome.age".publicKeys = systems ++ users;
  "forgejo-db.age".publicKeys = systems ++ users;
}
