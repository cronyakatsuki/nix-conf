{...}: {
  imports = [
    ./uptime-kuma.nix
    ./ntfy-sh.nix
    ./wireguard.nix
    ./secrets.nix
    ./redlib.nix
    ./beszel-hub.nix
  ];
}
