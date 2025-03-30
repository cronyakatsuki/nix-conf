{lib, ...}: {
  imports = [
    ./neovim.nix
    ./shell.nix
    ./scripts.nix
    ./tmux.nix
    ./zsh.nix
  ];

  crony.neovim.enable = lib.mkDefault true;
  crony.shell.enable = lib.mkDefault true;
  crony.tmux.enable = lib.mkDefault true;
  crony.zsh.enable = lib.mkDefault true;
  crony.scripts.enable = lib.mkDefault true;
}
