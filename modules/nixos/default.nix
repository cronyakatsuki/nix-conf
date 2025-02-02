{lib, ...}: {
  imports = [
    ./bluetooth.nix
    ./nvidia.nix
    ./plasma.nix
    ./disable-hibernation.nix
    ./gaming.nix
    ./zsh.nix
    ./stylix.nix
    ./nbfc.nix
    ./ryzenadj.nix
    ./qemu.nix
    ./amdgpu.nix
    ./nfs-share.nix
    ./auto-cpufreq.nix
    ./wireguard.nix
    ./hyprland.nix
  ];

  crony.bluetooth.enable = lib.mkDefault true;
  crony.nvidia.enable = lib.mkDefault true;
  crony.plasma.enable = lib.mkDefault true;
  crony.hibernation.disable = lib.mkDefault true;
  crony.gaming.enable = lib.mkDefault true;
  crony.zsh.enable = lib.mkDefault true;
  crony.stylix.enable = lib.mkDefault true;
  crony.nbfc.enable = lib.mkDefault true;
  crony.ryzenadj.enable = lib.mkDefault true;
  crony.qemu.enable = lib.mkDefault true;
  crony.amdgpu.enable = lib.mkDefault true;
  crony.nfs-share.enable = lib.mkDefault true;
  crony.auto-cpufreq.enable = lib.mkDefault true;
  crony.wireguard.enable = lib.mkDefault true;
  crony.hyprland-nixos.enable = lib.mkDefault true;
}
