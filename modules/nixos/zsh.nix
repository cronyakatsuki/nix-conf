{
  config,
  lib,
  pkgs,
  ...
}: {
  options = {
    crony.zsh.enable = lib.mkEnableOption "install and enable zsh for all users";
  };

  config = lib.mkIf config.crony.zsh.enable {
    # Installing zsh
    programs.zsh.enable = true;
    users.defaultUserShell = pkgs.zsh;
    environment.pathsToLink = ["/share/zsh"];
  };
}
