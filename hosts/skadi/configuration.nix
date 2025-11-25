{
  inputs,
  config,
  pkgs,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./disk-config.nix
    inputs.home-manager.nixosModules.home-manager
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Enable aarch64 emulation
  boot.binfmt.emulatedSystems = ["aarch64-linux"];

  # Disable intel watchdog for good
  boot.blacklistedKernelModules = ["intel_pmc_bxt" "iTCO_vendor_support" "iTCO_wdt"];

  # Use the xanmod kernel
  boot.kernelPackages = pkgs.linuxPackages_cachyos-lto;
  services.scx = {
    enable = true;
    scheduler = "scx_lavd";
    extraArgs = ["--performance" "--no-core-compaction"];
  };

  # Get nicer hostname
  networking.hostName = "skadi"; # Define your hostname.

  # Enable flakes
  nix.settings.experimental-features = ["nix-command" "flakes"];

  # Enable trusted users
  nix.settings.trusted-users = ["root" "@wheel"];

  # Setup gpu
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {
    modesetting.enable = true;
    open = true;
    nvidiaSettings = true;
  };

  # Enable networking
  networking.networkmanager.enable = true;
  networking.nameservers = ["192.168.0.5"];
  services.resolved = {
    enable = true;
    fallbackDns = ["192.168.0.5"];
  };

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

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
    options = "caps:escape";
  };

  # Enable seatd
  services.seatd.enable = true;

  # Enable flatpak
  services.flatpak = {
    enable = true;
    packages = [
      "com.dec05eba.gpu_screen_recorder"
    ];

    uninstallUnmanaged = true;

    update.auto = {
      enable = true;
      onCalendar = "weekly";
    };
  };

  networking.firewall.allowedTCPPorts = [42000 42001];

  # Enable coolercontrol to setup fancurves
  programs.coolercontrol = {
    enable = true;
  };

  # Setup gpu fan curves and light undervolt
  services.lact.enable = true;

  # Setup rgb control
  services.hardware.openrgb.enable = true;

  # Needed modules to have fan control and ntsync
  boot.kernelModules = ["coretemp" "nct6775" "ntsync"];

  # Enable ratbagd to customize mouse options
  services.ratbagd.enable = true;

  # Enable dconf
  programs.dconf.enable = true;

  # Enable AAGL
  programs.anime-game-launcher.enable = true;

  # Enable sound with pipewire.
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    pulse.enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
    extraConfig = {
      pipewire."99-silent.bell.conf" = {
        "context.properties" = {
          "modules.x11.bell" = false;
        };
      };
      pipewire."92-low-latency" = {
        "context.properties" = {
          "default.clock.rate" = 48000;
          "default.clock.quantum" = 64;
          "default.clock.min-quantum" = 64;
          "default.clock.max-quantum" = 64;
        };
      };
      pipewire-pulse."92-low-latency" = {
        "context.properties" = [
          {
            name = "libpipewire-module-protocol-pulse";
            args = {};
          }
        ];
        "pulse.properties" = {
          "pulse.min.req" = "64/48000";
          "pulse.default.req" = "64/48000";
          "pulse.max.req" = "64/48000";
          "pulse.min.quantum" = "64/48000";
          "pulse.max.quantum" = "64/48000";
        };
        "stream.properties" = {
          "node.latency" = "64/48000";
          "resample.quality" = 1;
        };
      };
    };
  };

  # Fix not saving my state
  hardware.alsa.enablePersistence = true;

  programs.niri.enable = true;

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
    hashedPasswordFile = "${config.age.secrets.crony-passwd.path}";
    extraGroups = ["networkmanager" "wheel" "video" "input" "audio" "gamemode" "seat" "realtime" "uinput"];
  };

  users.users.root.hashedPasswordFile = "${config.age.secrets.root-passwd.path}";

  users.mutableUsers = false;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Allow Broken Packages
  nixpkgs.config.allowBroken = true;

  # Setup community cache
  nix.settings = {
    substituters = [
      "https://nix-community.cachix.org"
      "https://hyprland.cachix.org"
      "https://ezkea.cachix.org"
    ];
    trusted-substituters = [
      "https://hyprland.cachix.org"
    ];
    trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      "ezkea.cachix.org-1:ioBmUbJTZIKsHmWWXPe1FSFbeVe+afhfgqgTSNd34eI="
    ];
  };

  # setup custom packages
  nixpkgs = {
    overlays = [
      (final: prev: {
        # Fix for wl-clipboard not having support for not setting sensitive for password managers
        wl-clipboard = prev.wl-clipboard.overrideAttrs (old: {
          version = "24-04-25";
          src = prev.fetchFromGitHub {
            owner = "bugaevc";
            repo = "wl-clipboard";
            rev = "aaa927ee7f7d91bcc25a3b68f60d01005d3b0f7f";
            hash = "sha256-V8JAai4gZ1nzia4kmQVeBwidQ+Sx5A5on3SJGSevrUU=";
          };
        });
      })
      (import inputs.emacs-overlay)
    ];
  };

  # Permit some insecure pacakges
  nixpkgs.config.permittedInsecurePackages = [
    "ventoy-1.1.07"
  ];

  # Optimise storage
  nix.optimise = {
    automatic = true;
    dates = ["weekly"];
  };

  # Enable my flake specific settings
  crony.gaming.enable = true;
  crony.additional-hardware.enable = true;
  crony.hyprland-nixos.enable = true;
  crony.nfs-share.enable = true;
  crony.sddm.enable = true;
  crony.wireguard.enable = true;
  crony.secrets.enable = true;
  crony.boot.enable = true;
  # crony.ollama.enable = true;
  crony.sunshine.enable = true;

  # Mount additional drive for games
  fileSystems."/mnt/games" = {
    device = "/dev/disk/by-uuid/f747508e-6b2f-474a-88cf-759a221cff46";
    fsType = "btrfs";
    options = [
      "compress=zstd"
      "noatime"
    ];
  };

  # Mount drives for backups
  fileSystems."/mnt/backup" = {
    device = "/dev/disk/by-uuid/3f2ab7ec-5b78-4686-b909-77fa6f4241b5";
    fsType = "btrfs";
    options = [
      "compress=zstd"
      "noatime"
    ];
  };

  # List packages installed in system profile
  environment.systemPackages = with pkgs; [
    neovim
    lm_sensors
    libva-utils
    alsa-utils
    xwayland-satellite
  ];

  # Enable nixd to see nixpkgs path
  nix.nixPath = ["nixpkgs=${inputs.nixpkgs}"];

  # DO NOT CHANGE
  system.stateVersion = "24.11";
}
