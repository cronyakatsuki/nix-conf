{...}: {
  services.openssh = {
    enable = true;
    settings = {
      AllowUsers = ["root@65.21.241.194" "root@172.16.0.2" "crony@65.21.241.194" "crony@172.16.0.2"];
      X11Forwarding = false;
      PasswordAuthentication = false;
    };
    extraConfig = ''
      PubkeyAuthentication yes
      PermitEmptyPasswords no

      AddressFamily inet
      MaxAuthTries 3
    '';
  };

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBJLduAXHWJiglmfRfkBGKffzVWkJP6porxIzw6+Zz3W crony@cronyakatsuki.xyz"
  ];

  services.fail2ban = {
    enable = true;
    maxretry = 5;
    ignoreIP = [
      "65.21.241.194"
    ];
    bantime = "24h"; # Ban IPs for one day on the first ban
    bantime-increment = {
      enable = true; # Enable increment of bantime after each violation
      multipliers = "1 2 4 8 16 32 64";
      maxtime = "168h"; # Do not ban for more than 1 week
      overalljails = true; # Calculate the bantime based on all the violations
    };
  };
}
