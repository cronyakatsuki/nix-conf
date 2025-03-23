{pkgs, ...}: {
  home.username = "banir";
  home.homeDirectory = "/home/banir";
  home.stateVersion = "24.11";

  programs.home-manager.enable = true;

  imports = [../../modules/cross-platform/home-manager/zsh.nix];

  crony.zsh.enable = true;

  programs.starship.enable = true;
}
