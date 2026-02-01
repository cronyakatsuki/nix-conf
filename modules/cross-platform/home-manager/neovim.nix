{
  config,
  inputs,
  pkgs,
  lib,
  ...
}: {
  options = {
    crony.neovim.enable = lib.mkEnableOption "Enable neovim and apply a good config.";
  };

  config = lib.mkIf config.crony.neovim.enable {
    # Disable stylix for nvf, I wan't to use a properly implemented theme sorry.
    stylix.targets.neovim.enable = false;

    # Setup neovim with default home manager options
    programs.neovim = {
      enable = true;
      package = inputs.neovim-nightly-overlay.packages.${pkgs.stdenv.hostPlatform.system}.default;
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;
      withNodeJs = true;
      withPython3 = true;
      withRuby = true;
      extraPackages = [
        # for treesitter
        pkgs.gcc
        # For nix
        pkgs.nixd
        pkgs.alejandra
        # for lua
        pkgs.lua-language-server
        # for webdevelopment json/html/...
        pkgs.vscode-langservers-extracted
        # for markdown
        pkgs.marksman
        # for yaml
        pkgs.yaml-language-server
        # for shell scripts
        pkgs.bash-language-server
        # for justfile
        pkgs.just-lsp
      ];
    };
  };
}
