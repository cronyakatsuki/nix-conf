{
  # Setup ntp
  services.timesyncd.enable = true;

  # Setup zram
  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 100;
    priority = 100;
  };
}
