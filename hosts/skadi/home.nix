{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    inputs.nvf.homeManagerModules.default
    inputs.nix-index-database.homeModules.nix-index
    inputs.nix-flatpak.homeManagerModules.nix-flatpak
    inputs.agenix.homeManagerModules.default
  ];

  # Some info
  home.username = "crony";
  home.homeDirectory = "/home/crony";

  # Enable syncthing
  services.syncthing.enable = true;

  # Default environmental variables
  home.sessionVariables = {
    EDITOR = "nvim";
    TERMINAL = "foot";
    WINEPREFIX = "$HOME/.local/share/wineprefix/default";
    SECOND_BRAIN = "$HOME/docs/sb";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Easyeffects
  services.easyeffects.enable = true;

  # Fix missing icons
  gtk = {
    enable = true;
    iconTheme = {
      package = pkgs.adwaita-icon-theme;
      name = "Adwaita";
    };
  };

  # Enable crony flake specific settings
  crony.mangohud.enable = true;
  crony.gaming.enable = true;
  crony.flatpak.enable = true;
  crony.wayland.enable = true;
  crony.hyprland.enable = true;
  crony.neovim.enable = true;
  # crony.qutebrowser.enable = true;
  crony.mpv.enable = true;
  # crony.browsers.enable = true;
  crony.desktop.enable = true;
  crony.shell-additions.enable = true;
  crony.home-secrets.enable = true;
  crony.restic.enable = true;
  crony.emulators.enable = true;
  # crony.emacs.enable = true;
  crony.zen-browser.enable = true;

  home.packages = [
    inputs.lnxlink.packages.${pkgs.system}.default
  ];

  systemd.user.services.lnxlink = {
    Unit = {
      Description = "LNXLlink";
      After = ["network-online.target" "mutli-user.target" "graphical.target"];
      PartOf = ["graphical-session.target"];
    };
    Install = {
      WantedBy = ["default.target"];
    };
    Service = {
      WorkingDirectory = "/home/crony/.config/lnxlink";
      Type = "simple";
      Restart = "always";
      RestartSec = 5;
      ExecStart = "${inputs.lnxlink.packages.${pkgs.system}.default}/bin/lnxlink --config /home/crony/.config/lnxlink/config.yaml";
    };
  };

  # DO NOT CHANGE ALSO
  home.stateVersion = "24.11"; # Please read the comment before changing.
}
