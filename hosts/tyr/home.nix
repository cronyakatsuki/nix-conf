{inputs, ...}: {
  imports = [
    inputs.nix-index-database.homeModules.nix-index
    inputs.nix-flatpak.homeManagerModules.nix-flatpak
    inputs.agenix.homeManagerModules.default
  ];

  # Some info
  home.username = "crony";
  home.homeDirectory = "/home/crony";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # DO NOT CHANGE
  home.stateVersion = "24.11"; # Please read the comment before changing.
}
