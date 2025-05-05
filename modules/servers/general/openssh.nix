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

  services.fail2ban.enable = true;
}
