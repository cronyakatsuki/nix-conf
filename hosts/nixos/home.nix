{
  pkgs,
  inputs,
  ...
}: {
  imports = [inputs.nvf.homeManagerModules.default];

  # Some info
  home.username = "crony";
  home.homeDirectory = "/home/crony";

  # PACKAGES
  home.packages = with pkgs; [
    alejandra
    keepassxc
    restic
    age
    nix-output-monitor
    nvd
    thunderbird
    sesh
    nurl
    entr
    ffmpeg
    spice-gtk
  ];

  # Install librewolf
  programs.librewolf.enable = true;

  # Install foot
  programs.foot.enable = true;

  # Enable theming chromium + use ungoogled chromium package
  programs.chromium = {
    enable = true;
    package = pkgs.ungoogled-chromium;
  };

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

  # Install btop
  programs.btop.enable = true;

  # Default environmental variables
  home.sessionVariables = {
    EDITOR = "nvim";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Fix gtkrc-2.0 collision
  home.file."/home/crony/.gtkrc-2.0".force = true;

  # DO NOT CHANGE ALSO
  home.stateVersion = "24.11"; # Please read the comment before changing.
}
