{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    inputs.nvf.homeManagerModules.default
    inputs.nix-index-database.hmModules.nix-index
  ];

  # Some info
  home.username = "crony";
  home.homeDirectory = "/home/crony";

  # PACKAGES
  home.packages = with pkgs; [
    alejandra
    keepassxc
    age
    nix-output-monitor
    nvd
    tutanota-desktop
    nurl
    entr
    ffmpeg
    imagemagick
    glow
    spice-gtk
    vesktop
    buku
    piper
    heroic
    prismlauncher
    protonup-qt
    protontricks
    jellyfin-mpv-shim
    itch
    wineWowPackages.staging
    rpcs3
    unzip
    p7zip
    aria2
    osu-lazer-bin
    overskride
    delfin
  ];

  # Install librewolf
  programs.librewolf = {
    enable = true;
    nativeMessagingHosts = with pkgs; [
      tridactyl-native
      bukubrow
      keepassxc
    ];
  };

  # This tricks messaging hosts into working for no
  # real reason other than to make me rage at hour of debugging
  # (5 hours in total)
  programs.firefox = {
    package = pkgs.librewolf;
    enable = true;
    nativeMessagingHosts = with pkgs; [
      tridactyl-native
      bukubrow
      keepassxc
    ];
  };

  programs.thunderbird = {
    enable = true;
    profiles.default.isDefault = true;
  };

  # Install foot
  programs.foot.enable = true;

  # Install imv
  programs.imv.enable = true;

  # Enable theming chromium + use ungoogled chromium package
  programs.chromium = {
    enable = true;
    package = pkgs.ungoogled-chromium;
    # Fix for wayland
    commandLineArgs = [
      "--ozone-platform-hint=auto"
      "--ozone-platform=wayland"
    ];
  };

  # Enable nix-index
  programs.nix-index = {
    enable = true;
    enableZshIntegration = true;
  };

  # Enable comma
  programs.nix-index-database.comma.enable = true;

  # Enable git
  programs.git = {
    enable = true;
    userName = "Crony Akatsuki";
    userEmail = "crony@cronyakatsuki.xyz";
  };

  # Enable syncthing
  services.syncthing.enable = true;

  # Install fzf
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    defaultCommand = "fd --type f";
  };

  # Install starship
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      add_newline = false;
    };
  };

  # Install zoxide
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  # Install eza
  programs.eza = {
    enable = true;
    enableZshIntegration = true;
    git = true;
    icons = "always";
  };

  # Install direnv
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  # Install the fuck
  programs.thefuck = {
    enable = true;
    enableZshIntegration = true;
  };

  # Install tealdeer
  programs.tealdeer.enable = true;

  # Install bat
  programs.bat.enable = true;

  # Install jq
  programs.jq.enable = true;

  # Install fd
  programs.fd = {
    enable = true;
    hidden = true;
    ignores = ["~/Documents/Share" ".git"];
  };

  # Install rg
  programs.ripgrep = {
    enable = true;
  };

  # Install btop
  programs.btop.enable = true;

  # Default environmental variables
  home.sessionVariables = {
    EDITOR = "nvim";
    WINEPREFIX = "$HOME/.local/share/wineprefix/default";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Fix gtkrc-2.0 collision
  home.file."/home/crony/.gtkrc-2.0".force = true;

  # DO NOT CHANGE ALSO
  home.stateVersion = "24.11"; # Please read the comment before changing.
}
