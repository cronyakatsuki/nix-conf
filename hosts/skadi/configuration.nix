{
  inputs,
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./disk-config.nix
    inputs.home-manager.nixosModules.home-manager
  ];

  # For tpm unlock
  boot.initrd.systemd.enable = true;

  # To explicitly disable systemd-boot, lanzaboote takes care of that.
  boot.loader.systemd-boot.enable = lib.mkForce false;

  # Bootloader.
  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/var/lib/sbctl";
    # autoEnrollKeys = {
    #   enable = true;
    # };
  };

  # Enable aarch64 emulation
  boot.binfmt.emulatedSystems = ["aarch64-linux"];

  # Disable intel watchdog for good
  boot.blacklistedKernelModules = ["intel_pmc_bxt" "iTCO_vendor_support" "iTCO_wdt"];

  # Use the cachyos kernel
  boot.kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-latest-lto-x86_64-v3;

  # Setup tmp as tmpfs
  boot.tmp.useTmpfs = true;

  # Setup userspace schedulers
  services.scx = {
    enable = true;
    scheduler = "scx_bpfland";
  };

  # Setup ananicy with cachyos rules
  services.ananicy = {
    enable = true;
    package = pkgs.ananicy-cpp;
    rulesProvider = pkgs.ananicy-rules-cachyos;
  };

  # Setup power profiles daemon
  services.power-profiles-daemon = {
    enable = true;
  };

  # Setup profiles sync daemon
  services.psd.enable = true;

  # Setup automatic usb device mounting
  services.udisks2.enable = true;

  # Get nicer hostname
  networking.hostName = "skadi"; # Define your hostname.

  # Setup gpu
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # Setup nvidia drivers
  services.xserver.videoDrivers = lib.mkIf (config.specialisation != {}) ["nvidia"];
  hardware.nvidia = {
    modesetting.enable = true;
    open = true;
    nvidiaSettings = true;
    powerManagement.enable = true;
  };

  # Early KMS: load nvidia in the initrd so it owns the framebuffer from the
  # very start of boot, instead of simpledrm holding it for several seconds
  # and fbcon re-drawing stale firmware-logo content at the wrong stride when
  # nvidia-drm takes over mid-boot (the torn/tiled ASUS logo). Same order the
  # nvidia nixos module itself uses for its (late) boot.kernelModules.
  boot.initrd.kernelModules = ["nvidia" "nvidia_modeset" "nvidia_drm"];

  # NOTE: tried nvidia-drm.fbdev=0 here to stop fbcon replaying a stale
  # console snapshot at DRM-master handoffs. Reverted: it removes the vt
  # framebuffer entirely, which made Hyprland's VT takeover racy (worked
  # once, failed/corrupted twice in a row) - not worth it for a cosmetic fix.

  specialisation = {
    nvk.configuration = {
      hardware.nvidia.open = lib.mkForce false;
      # Don't pull nvidia into the initrd under the nvk specialisation.
      boot.initrd.kernelModules = lib.mkForce [];
    };
  };

  # Enable networking
  networking.networkmanager = {
    enable = true;
    wifi.backend = "iwd";
  };
  networking.nameservers = ["192.168.0.5"];
  services.resolved = {
    enable = true;
    settings.Resolve.FallbackDns = ["192.168.0.5"];
  };

  # Enable bpftune for better networking
  services.bpftune.enable = true;

  # Setup vial udev rule
  hardware.keyboard.qmk.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Zagreb";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "hr_HR.UTF-8";
    LC_IDENTIFICATION = "hr_HR.UTF-8";
    LC_MEASUREMENT = "hr_HR.UTF-8";
    LC_MONETARY = "hr_HR.UTF-8";
    LC_NAME = "hr_HR.UTF-8";
    LC_NUMERIC = "hr_HR.UTF-8";
    LC_PAPER = "hr_HR.UTF-8";
    LC_TELEPHONE = "hr_HR.UTF-8";
    LC_TIME = "hr_HR.UTF-8";
  };

  networking.firewall.allowedTCPPorts = [42000 42001];

  # Enable appimages
  programs.appimage = {
    enable = true;
    binfmt = true;
  };

  # Enable polkit
  security.polkit.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.crony = {
    isNormalUser = true;
    description = "Crony";
    # hashedPasswordFile = "${config.age.secrets.crony-passwd.path}";
    extraGroups = ["networkmanager" "wheel" "video" "input" "audio" "gamemode" "seat" "pipewire"];
  };

  # users.users.root.hashedPasswordFile = "${config.age.secrets.root-passwd.path}";

  # users.mutableUsers = false;

  # Enable my flake specific settings
  crony.pipewire.enable = true;
  crony.gaming.enable = true;
  crony.additional-hardware.enable = true;
  crony.hyprland-nixos.enable = true;
  crony.nfs-share.enable = true;
  crony.sddm.enable = true;
  crony.secrets.enable = true;
  crony.wireguard.enable = true;
  crony.boot.enable = true;
  # crony.ollama.enable = true;
  # crony.sunshine.enable = true;
  crony.bluetooth.enable = true;
  crony.localsend.enable = true;
  crony.flatpak.enable = true;
  # crony.qemu.enable = true;
  crony.pc-services.enable = true;
  crony.cachyos.settings.enable = true;

  # Mount additional drive for games
  fileSystems."/mnt/games" = {
    device = "/dev/disk/by-uuid/f747508e-6b2f-474a-88cf-759a221cff46";
    fsType = "btrfs";
    options = [
      "compress-force=zstd:3"
      "noatime"
      "ssd"
      "discard=async"
      "space_cache=v2"
    ];
  };

  # Mount drives for backups
  fileSystems."/mnt/backup" = {
    device = "/dev/disk/by-uuid/3f2ab7ec-5b78-4686-b909-77fa6f4241b5";
    fsType = "btrfs";
    options = [
      "compress-force=zstd:3"
      "noatime"
      "ssd"
      "discard=async"
      "space_cache=v2"
    ];
  };

  # List packages installed in system profile
  environment.systemPackages = with pkgs; [
    neovim
    lm_sensors
    libva-utils
    alsa-utils
    ddcutil
    vial
  ];

  # DO NOT CHANGE
  system.stateVersion = "24.11";
}
