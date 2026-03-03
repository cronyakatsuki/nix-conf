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
    ./emacs.nix
    ./zen-browser.nix
    ./lnxlink.nix
  ];

  crony.river.enable = lib.mkDefault false;
  crony.wayland.enable = lib.mkDefault false;
  crony.qutebrowser.enable = lib.mkDefault false;
  crony.mangohud.enable = lib.mkDefault false;
  crony.nnn.enable = lib.mkDefault false;
  crony.mpv.enable = lib.mkDefault false;
  crony.obs-studio.enable = lib.mkDefault false;
  crony.restic.enable = lib.mkDefault false;
  crony.hyprland.enable = lib.mkDefault false;
  crony.browsers.enable = lib.mkDefault false;
  crony.emulators.enable = lib.mkDefault false;
  crony.desktop.enable = lib.mkDefault false;
  crony.gaming.enable = lib.mkDefault false;
  crony.shell-additions.enable = lib.mkDefault false;
  crony.flatpak.enable = lib.mkDefault false;
  crony.newsboat.enable = lib.mkDefault false;
  crony.xdg-user-dirs.enable = lib.mkDefault true;
  crony.pipewire.enable = lib.mkDefault true;
  crony.home-secrets.enable = lib.mkDefault false;
  crony.emacs.enable = lib.mkDefault false;
  crony.zen-browser.enable = lib.mkDefault false;
  crony.lnxlink.enable = lib.mkDefault false;
}
