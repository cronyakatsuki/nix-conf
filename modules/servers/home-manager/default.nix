{inputs, ...}: {
  home-manager.useGlobalPkgs = true;
  home-manager.extraSpecialArgs = {inherit inputs;};
  home-manager.backupFileExtension = "backup";
  home-manager.users.root = {
    imports = [
      ./home.nix
    ];
  };
}
