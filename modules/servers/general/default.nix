{...}: {
  imports = [
    ./openssh.nix
    ./user.nix
    ./traefik.nix
    ./secrets.nix
  ];
}
