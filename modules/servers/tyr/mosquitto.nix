{
  services.mosquitto = {
    enable = true;
    listeners = [
      {
        users.crony = {
          acl = ["readwrite #"];
          hashedPassword = "$7$101$3MqAfbz8vp9VMrMG$nvHnl1fEX1H3JeH98JGBjdBiKZ02RW7kSBMSQK2fHzU+3hinebJxW8QMpdaH9TYKoeM9PS0y+pzvYnrk0/tkIQ==";
        };
      }
    ];
  };

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [1883];
  };
}
