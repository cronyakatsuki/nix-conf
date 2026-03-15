{
  pkgs,
  config,
  ...
}: {
  services.gitea-actions-runner = {
    package = pkgs.forgejo-runner;
    instances.default = {
      enable = true;
      name = "monolith";
      url = "https://git.cronyakatsuki.xyz";
      tokenFile = config.age.secrets.forgejo-runner-token.path;
      labels = [
        ## optionally provide native execution on the host:
        "debian-latest:docker://node:18-bullseye"
        "native:host"
        "ubuntu-latest:docker://ghcr.io/catthehacker/ubuntu:act-24.04"
      ];
      hostPackages = with pkgs; [
        bash
        coreutils
        curl
        gawk
        gitMinimal
        gnused
        nodejs
        wget
        nix
        attic-client
      ];
    };
  };

  environment.systemPackages = with pkgs; [attic-client];

  nix.settings.trusted-users = ["root" "gitea-runner" "@wheel"];

  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 16 * 1024; # 16 GB
    }
  ];

  nix.settings.max-jobs = 1;
}
