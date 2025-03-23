{
  pkgs,
  inputs,
  ...
}: {
  home.username = "banir";
  home.homeDirectory = "/home/banir";
  home.stateVersion = "24.11";

  programs.home-manager.enable = true;

  imports = [
    ../../modules/cross-platform/home-manager/zsh.nix
    ../../modules/cross-platform/home-manager/neovim.nix
    inputs.nvf.homeManagerModules.default
    inputs.stylix.homeManagerModules.default
  ];

  crony.zsh.enable = true;
  crony.neovim.enable = true;

  programs.starship.enable = true;
}
