{
  config,
  inputs,
  pkgs,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./disk-config.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Get nicer hostname
  networking.hostName = "tyr"; # Define your hostname.

  networking.useNetworkd = true;

  # Enable and setup networking
  networking.interfaces.enp1s0.ipv4.addresses = [
    {
      address = "192.168.0.5";
      prefixLength = 24;
    }
  ];
  networking.defaultGateway = {
    interface = "enp1s0";
    address = "192.168.0.1";
  };
  networking.nameservers = ["127.0.0.1"];
  services.resolved = {
    enable = true;
    settings.Resolve.FallbackDND = ["127.0.0.1"];
  };

  # Setup gpu
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
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

  # Setup bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  hardware.bluetooth.settings = {
    General = {
      Enable = "Source,Sink,Media,Socket";
      Experimental = true;
    };
  };

  # Setup dbus broker
  services.dbus = {
    enable = true;
    implementation = "broker";
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Setup community cache
  nix.settings = {
    substituters = [
      "https://nix-community.cachix.org"
    ];
    trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  # Setup iperf3
  services.iperf3 = {
    enable = true;
    openFirewall = true;
  };

  # Enable nixd to see nixpkgs path
  nix.nixPath = ["nixpkgs=${inputs.nixpkgs}"];

  # DO NOT CHANGE
  system.stateVersion = "24.11";
}
