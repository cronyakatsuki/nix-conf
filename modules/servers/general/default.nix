{...}: {
  imports = [
    ./openssh.nix
    ./user.nix
    ./traefik.nix
    ./secrets.nix
    ./podman.nix
    ./additional-pkgs.nix
  ];
}
