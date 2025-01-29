{lib, ...}: {
  imports = [./bluetooth.nix ./nvidia.nix ./plasma.nix ./disable-hibernation.nix ./gaming.nix ./zsh.nix ./stylix.nix];

  crony.bluetooth.enable = lib.mkDefault true;
  crony.nvidia.enable = lib.mkDefault true;
  crony.plasma.enable = lib.mkDefault true;
  crony.hibernation.disable = lib.mkDefault true;
  crony.gaming.enable = lib.mkDefault true;
  crony.zsh.enable = lib.mkDefault true;
  crony.stylix.enable = lib.mkDefault true;
}
