{lib, ...}: {
  imports = [
    ./mangohud.nix
    ./neovim.nix
    ./zsh.nix
    ./tmux.nix
    ./nnn.nix
    ./mpv.nix
    ./obs-studio.nix
    ./nh.nix
    ./restic.nix
    ./hyprland.nix
    ./browsers
  ];

  crony.mangohud.enable = lib.mkDefault true;
  crony.neovim.enable = lib.mkDefault true;
  crony.zsh.enable = lib.mkDefault true;
  crony.tmux.enable = lib.mkDefault true;
  crony.nnn.enable = lib.mkDefault true;
  crony.mpv.enable = lib.mkDefault true;
  crony.obs-studio.enable = lib.mkDefault true;
  crony.nh.enable = lib.mkDefault true;
  crony.restic.enable = lib.mkDefault true;
  crony.hyprland.enable = lib.mkDefault true;
  crony.browsers.enable = lib.mkDefault true;
}
