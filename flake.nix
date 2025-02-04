{
  description = "Nixos config flake";

  inputs = {
    # Use unstable packages ( which are amazing )
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # YEI, HOME MANAGER
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Let's theme everything easilly
    stylix.url = "github:danth/stylix";

    # NVF FOR SUPER NVIM
    nvf = {
      url = "github:notashelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # auto-cpufreq latest version, for optimizing my laptop's thermal's
    auto-cpufreq = {
      url = "github:AdnanHodzic/auto-cpufreq";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # ags for cool widgets
    ags.url = "github:aylur/ags";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    auto-cpufreq,
    ...
  } @ inputs: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs;};
      modules = [
        # Get the system config
        ./hosts/nixos/configuration.nix
        # Enable stylix
        inputs.stylix.nixosModules.stylix
        # Load updated auto-cpufreq
        auto-cpufreq.nixosModules.default
        # Load my modules
        ./modules/nixos
        # Setup home manager for my user
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.extraSpecialArgs = {inherit inputs;};
          home-manager.backupFileExtension = "backup";
          home-manager.users.crony = {
            imports = [
              ./hosts/nixos/home.nix
              ./modules/home-manager
              inputs.ags.homeManagerModules.default
            ];
          };
        }
      ];
    };
  };
}
