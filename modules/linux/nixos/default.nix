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
    ./oom.nix
    ./boot.nix
  ];

  crony.bluetooth.enable = lib.mkDefault true;
  crony.nvidia.enable = lib.mkDefault false;
  crony.plasma.enable = lib.mkDefault false;
  crony.hibernation.disable = lib.mkDefault true;
  crony.gaming.enable = lib.mkDefault false;
  crony.zsh.enable = lib.mkDefault true;
  crony.stylix.enable = lib.mkDefault true;
  crony.nbfc.enable = lib.mkDefault false;
  crony.ryzenadj.enable = lib.mkDefault false;
  crony.qemu.enable = lib.mkDefault false;
  crony.amdgpu.enable = lib.mkDefault false;
  crony.nfs-share.enable = lib.mkDefault false;
  crony.auto-cpufreq.enable = lib.mkDefault false;
  crony.wireguard.enable = lib.mkDefault false;
  crony.hyprland-nixos.enable = lib.mkDefault false;
  crony.sddm.enable = lib.mkDefault false;
  crony.watchdog.disable = lib.mkDefault true;
  crony.general-services.enable = lib.mkDefault true;
  crony.additional-hardware.enable = lib.mkDefault false;
  crony.tailscale.enable = lib.mkDefault false;
  crony.sunshine.enable = lib.mkDefault false;
  crony.nh.enable = lib.mkDefault true;
  crony.ollama.enable = lib.mkDefault false;
  crony.secrets.enable = lib.mkDefault false;
  crony.oom.enable = lib.mkDefault true;
  crony.boot.enable = lib.mkDefault false;
}
