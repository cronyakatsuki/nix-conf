{pkgs, ...}: {
  users.extraUsers.root = {
    shell = pkgs.zsh;
  };

  programs.zsh.enable = true;
}
