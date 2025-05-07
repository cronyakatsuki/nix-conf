{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    inputs.home-manager.nixosModules.home-manager
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Enable aarch64 emulation
  boot.binfmt.emulatedSystems = ["aarch64-linux"];

  # Use the xanmod kernel
  boot.kernelPackages = pkgs.linuxKernel.packages.linux_xanmod_latest;

  # Get nicer hostname
  networking.hostName = "nixos"; # Define your hostname.

  # Enable flakes
  nix.settings.experimental-features = ["nix-command" "flakes"];

  # Enable trusted users
  nix.trustedUsers = ["root" "@wheel"];

  # Setup gpu
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # Enable networking
  networking.networkmanager.enable = true;
  networking.nameservers = ["192.168.0.10" "1.1.1.1"];
  services.resolved = {
    enable = true;
    fallbackDns = ["192.168.0.10" "1.1.1.1"];
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

  # Enable fstrim
  services.fstrim.enable = true;

  # Enable seatd
  services.seatd.enable = true;

  # Enable flatpak
  services.flatpak.enable = true;

  # Enable ratbagd to customize mouse options
  services.ratbagd.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    pulse.enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
  };
  # Fix not saving my state
  hardware.alsa.enablePersistence = true;

  # Enable appimages
  programs.appimage = {
    enable = true;
    binfmt = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.crony = {
    isNormalUser = true;
    description = "Crony";
    extraGroups = ["networkmanager" "wheel" "video" "input" "audio" "gamemode" "seat"];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile
  environment.systemPackages = with pkgs; [
    neovim
    lm_sensors
    libva-utils
    alsa-utils
  ];

  # Enable nixd to see nixpkgs path
  nix.nixPath = ["nixpkgs=${inputs.nixpkgs}"];

  # DO NOT CHANGE
  system.stateVersion = "24.11";
}
