{inputs, ...}: {
  # Enable flakes
  nix.settings.experimental-features = ["nix-command" "flakes"];

  # Enable trusted users
  nix.settings.trusted-users = ["root" "@wheel"];

  # Setup community cache
  nix.settings = {
    substituters = [
      "https://nix-community.cachix.org"
      "https://hyprland.cachix.org"
      "https://ezkea.cachix.org"
      "https://nix-gaming.cachix.org"
      "https://cache.nixos-cuda.org"
      "https://deploy-rs.cachix.org"
      "https://cache.xinux.uz"
    ];
    trusted-substituters = [
      "https://hyprland.cachix.org"
    ];
    trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      "ezkea.cachix.org-1:ioBmUbJTZIKsHmWWXPe1FSFbeVe+afhfgqgTSNd34eI="
      "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
      "cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M="
      "deploy-rs.cachix.org-1:xfNobmiwF/vzvK1gpfediPwpdIP0rpDV2rYqx40zdSI="
      "cache.xinux.uz:BXCrtqejFjWzWEB9YuGB7X2MV4ttBur1N8BkwQRdH+0="
    ];
  };

  # setup custom packages
  nixpkgs = {
    overlays = [
      (final: prev: {
        # Fix for wl-clipboard not having support for not setting sensitive for password managers
        wl-clipboard = prev.wl-clipboard.overrideAttrs (old: {
          version = "24-04-25";
          src = prev.fetchFromGitHub {
            owner = "bugaevc";
            repo = "wl-clipboard";
            rev = "aaa927ee7f7d91bcc25a3b68f60d01005d3b0f7f";
            hash = "sha256-V8JAai4gZ1nzia4kmQVeBwidQ+Sx5A5on3SJGSevrUU=";
          };
        });
      })
      (import inputs.emacs-overlay)
      inputs.nix-cachyos-kernel.overlays.pinned
      inputs.proton-cachyos.overlays.default
    ];
  };

  # Optimise storage
  nix.optimise = {
    automatic = true;
    dates = ["weekly"];
  };

  # Enable nixd to see nixpkgs path
  nix.nixPath = ["nixpkgs=${inputs.nixpkgs}"];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
}
