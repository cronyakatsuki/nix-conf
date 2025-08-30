{config, ...}: {
  # Not reall that safe but convenient af
  security.sudo.wheelNeedsPassword = false;

  users.users.crony = {
    hashedPasswordFile = "${config.age.secrets.crony-passwd.path}";
    isNormalUser = true;
    description = "crony";
    extraGroups = [
      "wheel"
    ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBJLduAXHWJiglmfRfkBGKffzVWkJP6porxIzw6+Zz3W crony@cronyakatsuki.xyz"
    ];
  };
}
