let
  # SYSTEMS
  heimdall = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBs+qYjpeAEHPFUQeatNkhKbXz8+A1VAl21jgifDYJK8";
  baldur = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOvZ7Z8GS4+1+9D6u/BDit4Eij5Ubbii2dzJ/+ecT8iR";
  bragi = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBKMV2vqlDvIkUefl5oEuVjVtjgFLEXyDKX2LWhVQsWT";
  thor = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHZGQLUhyLwmkTYhSccqO8umQJN0QHk6YaD863x7lcGv";
  odin = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBGfwv4CzZlPGsBukfoq5wBTlVfWJo7UHH7DP3ILP6/Z";
  freyja = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIODW4kBme9Vhx93AkPBwiTvcA7ad+rqLaEAhasMMhNzH";
  tyr = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB3McoNRZkk0hJXHv1MWSx/UklEmr2iZ26C7ctaNK/Ww";

  # USERS
  root = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAID2HeOFYaGmjP3OQzPuA+DSjkqfyYH4axoDPWKVP/jdU root@ymir";
  crony = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBJLduAXHWJiglmfRfkBGKffzVWkJP6porxIzw6+Zz3W crony@cronyakatsuki.xyz";
  root-skadi = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGJ85a6FAJqM8QhtGcrT3BGDs2G8m7DFtWNDh2Vvkr0V root@skadi";

  users = [root crony root-skadi];
  systems = [heimdall baldur bragi thor odin freyja tyr];
in {
  "traefik.age".publicKeys = systems ++ users;
  "wg-heimdall.age".publicKeys = systems ++ users;
  "wg-desktop.age".publicKeys = systems ++ users;
  "wg-home.age".publicKeys = systems ++ users;
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
  "restic-local-pass.age".publicKeys = systems ++ users;
  "restic-backblaze-pass.age".publicKeys = systems ++ users;
  "restic-backblaze-repo.age".publicKeys = systems ++ users;
  "restic-backblaze-env.age".publicKeys = systems ++ users;
  "restic-server-local-pass.age".publicKeys = systems ++ users;
  "restic-server-pass.age".publicKeys = systems ++ users;
  "restic-server-repo.age".publicKeys = systems ++ users;
  "restic-server-env.age".publicKeys = systems ++ users;
  "lemmy.env.age".publicKeys = systems ++ users;
  "wg-ymir-home.age".publicKeys = systems ++ users;
  "wg-tyr.age".publicKeys = systems ++ users;
  "duckdns.age".publicKeys = systems ++ users;
}
