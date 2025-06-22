{lib, ...}: {
  imports = [
    ./browsers
    ./desktop.nix
    ./emulators.nix
    ./gaming.nix
    ./hyprland.nix
    ./mangohud.nix
    ./mpv.nix
    ./nnn.nix
    ./obs-studio.nix
    ./restic.nix
    ./shell-additions.nix
    ./flatpak.nix
    ./newsboat.nix
    ./xdg-user-dirs.nix
    ./qutebrowser.nix
    ./wayland.nix
    ./river.nix
    ./pipewire.nix
    ./secrets.nix
  ];

  crony.river.enable = lib.mkDefault false;
  crony.wayland.enable = lib.mkDefault false;
  crony.qutebrowser.enable = lib.mkDefault true;
  crony.mangohud.enable = lib.mkDefault false;
  crony.nnn.enable = lib.mkDefault true;
  crony.mpv.enable = lib.mkDefault true;
  crony.obs-studio.enable = lib.mkDefault true;
  crony.restic.enable = lib.mkDefault false;
  crony.hyprland.enable = lib.mkDefault false;
  crony.browsers.enable = lib.mkDefault true;
  crony.emulators.enable = lib.mkDefault false;
  crony.desktop.enable = lib.mkDefault true;
  crony.gaming.enable = lib.mkDefault false;
  crony.shell-additions.enable = lib.mkDefault true;
  crony.flatpak.enable = lib.mkDefault false;
  crony.newsboat.enable = lib.mkDefault false;
  crony.xdg-user-dirs.enable = lib.mkDefault true;
  crony.pipewire.enable = lib.mkDefault true;
  crony.home-secrets.enable = lib.mkDefault false;
}
