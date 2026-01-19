{
  lib,
  inputs,
  host,
  name,
  ...
}: let
  baseModules = [
    inputs.disko.nixosModules.disko
    inputs.agenix.nixosModules.default
  ];
  clientDefaults =
    if host.type == "client"
    then [
      inputs.stylix.nixosModules.stylix
      ./modules/linux/nixos
    ]
    else [];
  serverExtras =
    if host.type == "server"
    then [
      # ./modules/servers/general
      ./modules/servers/${name}
      ./modules/servers/home-manager
    ]
    else [];
  specialModules =
    if host.type == "client"
    then [
      inputs.aagl.nixosModules.default
      inputs.auto-cpufreq.nixosModules.default
      inputs.nix-flatpak.nixosModules.nix-flatpak
      inputs.chaotic.nixosModules.default
      inputs.lanzaboote.nixosModules.lanzaboote
    ]
    else [];
  homeManagerModules =
    if host.type == "server"
    then [inputs.home-manager.nixosModules.home-manager]
    else [
      inputs.home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.extraSpecialArgs = {inherit inputs;};
        home-manager.backupFileExtension = "backup";
        home-manager.users.crony = {
          imports = [
            ./hosts/skadi/home.nix
            ./modules/linux/home-manager
            ./modules/cross-platform/home-manager
          ];
        };
      }
    ];
in {
  baseModules = baseModules;
  clientDefaults = clientDefaults;
  serverExtras = serverExtras;
  specialModules = specialModules;
  homeManagerModules = homeManagerModules;
}
