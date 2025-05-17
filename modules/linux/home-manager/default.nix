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
  ];

  crony.mangohud.enable = lib.mkDefault false;
  crony.nnn.enable = lib.mkDefault true;
  crony.mpv.enable = lib.mkDefault true;
  crony.obs-studio.enable = lib.mkDefault true;
  crony.restic.enable = lib.mkDefault false;
  crony.hyprland.enable = lib.mkDefault true;
  crony.browsers.enable = lib.mkDefault true;
  crony.emulators.enable = lib.mkDefault false;
  crony.desktop.enable = lib.mkDefault true;
  crony.gaming.enable = lib.mkDefault false;
  crony.shell-additions.enable = lib.mkDefault true;
  crony.flatpak.enable = lib.mkDefault false;
  crony.newsboat.enable = lib.mkDefault false;
}
