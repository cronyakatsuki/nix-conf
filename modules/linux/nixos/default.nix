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
    ./sddm.nix
    ./watchdog.nix
    ./general-services.nix
    ./additional-hardware
    ./tailscale.nix
    ./sunshine.nix
    ./nh.nix
    ./ollama.nix
    ./secrets.nix
  ];

  crony.bluetooth.enable = lib.mkDefault true;
  crony.nvidia.enable = lib.mkDefault true;
  crony.plasma.enable = lib.mkDefault false;
  crony.hibernation.disable = lib.mkDefault true;
  crony.gaming.enable = lib.mkDefault true;
  crony.zsh.enable = lib.mkDefault true;
  crony.stylix.enable = lib.mkDefault true;
  crony.nbfc.enable = lib.mkDefault true;
  crony.ryzenadj.enable = lib.mkDefault true;
  crony.qemu.enable = lib.mkDefault true;
  crony.amdgpu.enable = lib.mkDefault false;
  crony.nfs-share.enable = lib.mkDefault true;
  crony.auto-cpufreq.enable = lib.mkDefault true;
  crony.wireguard.enable = lib.mkDefault true;
  crony.hyprland-nixos.enable = lib.mkDefault true;
  crony.sddm.enable = lib.mkDefault true;
  crony.watchdog.disable = lib.mkDefault true;
  crony.general-services.enable = lib.mkDefault true;
  crony.additional-hardware.enable = lib.mkDefault true;
  crony.tailscale.enable = lib.mkDefault true;
  crony.sunshine.enable = lib.mkDefault true;
  crony.nh.enable = lib.mkDefault true;
  crony.ollama.enable = lib.mkDefault true;
}
