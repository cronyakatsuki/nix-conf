{...}: {
  services.umurmur = {
    enable = true;
    openFirewall = true;
    settings = {
      welcometext = "Welcome to crony's nutsack.";
    };
  };
}
