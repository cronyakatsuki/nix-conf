{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    aria2
    unzip
    lm_sensors
    neovim
    git
    htop
  ];
}
