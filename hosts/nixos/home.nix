{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    inputs.nvf.homeManagerModules.default
    inputs.nix-index-database.hmModules.nix-index
  ];

  # Some info
  home.username = "crony";
  home.homeDirectory = "/home/crony";

  # PACKAGES
  home.packages = with pkgs; [
    keepassxc
    tutanota-desktop
    spice-gtk
    vesktop
    piper
    heroic
    prismlauncher
    protonup-qt
    protontricks
    jellyfin-mpv-shim
    itch
    wineWowPackages.staging
    osu-lazer-bin
    overskride
    delfin
    # Setting up emulator just cause
    (retroarch.overrideAttrs {
      cores = with libretro; [
        beetle-saturn
        parallel-n64
        flycast
        desmume
      ];
    })
    duckstation
    pcsx2
    dolphin-emu
    xemu
    rpcs3
    cemu
    ppsspp-sdl-wayland
    mame-tools
  ];

  programs.thunderbird = {
    enable = true;
    profiles.default.isDefault = true;
  };

  # Install foot
  programs.foot.enable = true;

  # Install imv
  programs.imv.enable = true;

  # Enable syncthing
  services.syncthing.enable = true;

  # Default environmental variables
  home.sessionVariables = {
    EDITOR = "nvim";
    WINEPREFIX = "$HOME/.local/share/wineprefix/default";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Fix gtkrc-2.0 collision
  home.file."/home/crony/.gtkrc-2.0".force = true;

  # DO NOT CHANGE ALSO
  home.stateVersion = "24.11"; # Please read the comment before changing.
}
