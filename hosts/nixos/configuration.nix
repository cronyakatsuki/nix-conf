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

  # Use the xanmod kernel
  boot.kernelPackages = pkgs.linuxKernel.packages.linux_xanmod_latest;

  # Get nicer hostname
  networking.hostName = "nixos"; # Define your hostname.

  # Enable flakes
  nix.settings.experimental-features = ["nix-command" "flakes"];

  crony.plasma.enable = false;

  # Setup gpu
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # Setup OpenTabletDriver graphic tablet driver
  hardware.opentabletdriver.enable = true;

  # Enable networking
  networking.networkmanager.enable = true;

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

  # Enable upower
  services.upower.enable = true;

  # Enable ratbagd to customize mouse options
  services.ratbagd.enable = true;

  # Enable firmware updater
  services.fwupd.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.crony = {
    isNormalUser = true;
    description = "Crony";
    extraGroups = ["networkmanager" "wheel" "video" "input" "audio" "libvirtd"];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile
  environment.systemPackages = with pkgs; [
    neovim
    mangohud
    lm_sensors
  ];

  # Enable nixd to see nixpkgs path
  nix.nixPath = ["nixpkgs=${inputs.nixpkgs}"];

  # Enable zram swap device
  zramSwap.enable = true;

  # DO NOT CHANGE
  system.stateVersion = "24.11";
}
