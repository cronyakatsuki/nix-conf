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
      # Obtaining the path to the runner token file may differ
      # tokenFile should be in format TOKEN=<secret>, since it's EnvironmentFile for systemd
      tokenFile = config.age.secrets.forgejo-runner-token.path;
      labels = [
        ## optionally provide native execution on the host:
        "debian-latest:docker://node:18-bullseye"
        "native:host"
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
}
