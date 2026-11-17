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
    # NOTE: setting trusted-public-keys REPLACES nix's default list —
    # cache.nixos.org's key must always be kept here or every upstream
    # substitute is ignored and everything rebuilds from source.
    "cache.nixos.org-1:6NDOdD0kLvqqr6IpOy3DkNbK1Q4VV32FuGg4CF2xIb8="
  ];

  nixpkgs.config.allowUnfree = true;
}
