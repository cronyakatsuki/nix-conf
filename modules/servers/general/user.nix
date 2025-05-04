{...}: {
  users.users.crony = {
    password = "whatever i will change it right away";
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
