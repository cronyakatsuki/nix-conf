{pkgs, ...}: {
  users.extraUsers.root = {
    shell = pkgs.zsh;
  };

  users.extraUsers.crony = {
    shell = pkgs.zsh;
  };

  programs.zsh.enable = true;
}
