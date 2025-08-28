{inputs, ...}: {
  home-manager.useGlobalPkgs = true;
  home-manager.extraSpecialArgs = {inherit inputs;};
  home-manager.backupFileExtension = "backup";
  home-manager.users.root = {
    imports = [
      ./root.nix
    ];
  };
  home-manager.users.crony = {
    imports = [
      ./crony.nix
    ];
  };
}
