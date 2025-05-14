{
  config,
  pkgs,
  lib,
  ...
}: {
  # Module that bundles all my shell related software that make up my shell experience
  options = {
    crony.shell.enable = lib.mkEnableOption "Enable my bundled shell software that make up my shell experience";
  };

  config = lib.mkIf config.crony.shell.enable {
    home.packages = with pkgs; [
      alejandra
      age
      entr
      ffmpeg
      imagemagick
      glow
      buku
      unzip
      p7zip
      aria2
      commitizen
      license-go
      just
      dysk
    ];

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
  };
}
