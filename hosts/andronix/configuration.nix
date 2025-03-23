{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  # Simply install just the packages
  environment.packages = with pkgs; [
    ncurses
    busybox
    man
    openssh
    rsync
  ];

  # Backup etc files instead of failing to activate generation if a file already exists in /etc
  environment.etcBackupExtension = ".bak";

  # Read the changelog before changing this value
  system.stateVersion = "24.05";

  # Set up nix for flakes
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  # enable some android integrations.
  android-integration.termux-setup-storage.enable = true;

  # Set your time zone
  time.timeZone = "Europe/Zagreb";

  # change to zsh
  user.shell = "${pkgs.zsh}/bin/zsh";

  # Setup font
  terminal.font = "${pkgs.nerd-fonts.commit-mono}/share/fonts/opentype/NerdFonts/CommitMono/CommitMonoNerdFont-Regular.otf";

  # Configure home-manager
  home-manager = {
    config = ./home.nix;
    backupFileExtension = "hm-bak";
    useGlobalPkgs = true;
    extraSpecialArgs = {inherit inputs;};
  };

  # Add support for deploy-rs
  user.uid = 10292;
  user.gid = 10292;

  # Configure stylix
  stylix = {
    enable = true;
    autoEnable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-medium.yaml";
  };
}
