{pkgs, ...}: {
  home.username = "ivek";
  home.homeDirectory = "/home/ivek";
  home.stateVersion = "24.11";

  programs.home-manager.enable = true;
}
