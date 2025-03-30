{lib, ...}: {
  imports = [
    ./browsers
    ./desktop.nix
    ./emulators.nix
    ./gaming.nix
    ./hyprland.nix
    ./mangohud.nix
    ./mpv.nix
    ./nh.nix
    ./nnn.nix
    ./obs-studio.nix
    ./restic.nix
    ./shell-additions.nix
  ];

  crony.mangohud.enable = lib.mkDefault true;
  crony.nnn.enable = lib.mkDefault true;
  crony.mpv.enable = lib.mkDefault true;
  crony.obs-studio.enable = lib.mkDefault true;
  crony.nh.enable = lib.mkDefault true;
  crony.restic.enable = lib.mkDefault true;
  crony.hyprland.enable = lib.mkDefault true;
  crony.browsers.enable = lib.mkDefault true;
  crony.emulators.enable = lib.mkDefault true;
  crony.desktop.enable = lib.mkDefault true;
  crony.gaming.enable = lib.mkDefault true;
  crony.shell-additions.enable = lib.mkDefault true;
}
