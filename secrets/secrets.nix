let
  # SYSTEMS
  heimdall = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBs+qYjpeAEHPFUQeatNkhKbXz8+A1VAl21jgifDYJK8";
  loki = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIF+xpWCoBEO/pzAwS1ZZEsiLSarvSVkdxQEo49xma2PV";
  baldur = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOvZ7Z8GS4+1+9D6u/BDit4Eij5Ubbii2dzJ/+ecT8iR";
  bragi = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBKMV2vqlDvIkUefl5oEuVjVtjgFLEXyDKX2LWhVQsWT";
  thor = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHZGQLUhyLwmkTYhSccqO8umQJN0QHk6YaD863x7lcGv";
  odin = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBGfwv4CzZlPGsBukfoq5wBTlVfWJo7UHH7DP3ILP6/Z";

  # USERS
  root = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAID2HeOFYaGmjP3OQzPuA+DSjkqfyYH4axoDPWKVP/jdU root@ymir";
  crony = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBJLduAXHWJiglmfRfkBGKffzVWkJP6porxIzw6+Zz3W crony@cronyakatsuki.xyz";

  users = [root crony];
  systems = [heimdall loki baldur bragi thor odin];
in {
  "traefik.age".publicKeys = systems ++ users;
  "wg-heimdall.age".publicKeys = systems ++ users;
  "wg-desktop.age".publicKeys = systems ++ users;
  "rclone.age".publicKeys = systems ++ users;
  "navidrome.age".publicKeys = systems ++ users;
  "forgejo-db.age".publicKeys = systems ++ users;
  "plausible.age".publicKeys = systems ++ users;
  "conduit.age".publicKeys = systems ++ users;
  "searx.age".publicKeys = systems ++ users;
  "miniflux.age".publicKeys = systems ++ users;
  "crony-passwd-desktop.age".publicKeys = systems ++ users;
  "crony-passwd-servers.age".publicKeys = systems ++ users;
  "root-passwd.age".publicKeys = systems ++ users;
}
