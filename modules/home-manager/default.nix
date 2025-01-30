{lib, ...}: {
  imports = [./mangohud.nix ./neovim.nix ./zsh.nix ./tmux.nix];

  crony.mangohud.enable = lib.mkDefault true;
  crony.neovim.enable = lib.mkDefault true;
  crony.zsh.enable = lib.mkDefault true;
  crony.tmux.enable = lib.mkDefault true;
}
