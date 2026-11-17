{
  # Enable flakes
  nix.settings.experimental-features = ["nix-command" "flakes"];

  # Own binary cache (attic on heimdall) + upstream
  nix.settings.substituters = [
    "https://cache.cronyakatsuki.xyz/server"
    "https://cache.nixos.org"
  ];

  nix.settings.trusted-public-keys = [
    "server:ldTPuxHGjcPq3hKgl9yXIdWeBrG6UFiiGgZ9z5wAw3M="
  ];

  nixpkgs.config.allowUnfree = true;
}
