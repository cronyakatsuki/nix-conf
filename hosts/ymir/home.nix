{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    inputs.nvf.homeManagerModules.default
    inputs.nix-index-database.hmModules.nix-index
    inputs.nix-flatpak.homeManagerModules.nix-flatpak
  ];

  # Some info
  home.username = "crony";
  home.homeDirectory = "/home/crony";

  # Enable syncthing
  services.syncthing.enable = true;

  # Default environmental variables
  home.sessionVariables = {
    EDITOR = "nvim";
    WINEPREFIX = "$HOME/.local/share/wineprefix/default";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Enable crony flake specific settings
  crony.mangohud.enable = true;
  crony.gaming.enable = true;
  crony.flatpak.enable = true;

  # Fix gtkrc-2.0 collision
  home.file."/home/crony/.gtkrc-2.0".force = true;

  # DO NOT CHANGE ALSO
  home.stateVersion = "24.11"; # Please read the comment before changing.
}
