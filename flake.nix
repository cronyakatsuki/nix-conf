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
    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # NVF FOR SUPER NVIM
    nvf = {
      url = "github:notashelf/nvf";
    };

    # auto-cpufreq latest version, for optimizing my laptop's thermal's
    auto-cpufreq = {
      url = "github:AdnanHodzic/auto-cpufreq";
    };

    # use custom nbfc that has the config for my laptop
    nbfc-linux = {
      url = "github:cronyakatsuki/nbfc-linux/a715-41g";
    };

    # use prebuild nix-index ( crashes on me cause little ram )
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Add pre commit hooks
    git-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # iamb, a matrix tui client. Latest possible version
    iamb = {
      url = "github:ulyssa/iamb";
    };

    # Support for android
    nix-on-droid = {
      url = "github:nix-community/nix-on-droid/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    # Declare flatpak easilly
    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";

    # Neovim nightly
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";

    # Deploy-rs
    deploy-rs.url = "github:serokell/deploy-rs";

    # Disko
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    auto-cpufreq,
    git-hooks,
    nix-on-droid,
    deploy-rs,
    disko,
    ...
  } @ inputs: {
    deploy.nodes = {
      dedi = {
        hostname = "dedi";
        profiles.ivek = {
          sshUser = "ivek";
          user = "ivek";
          path = deploy-rs.lib.x86_64-linux.activate.home-manager self.homeConfigurations."ivek";
          sshOpts = [];
          magicRollback = false;
        };
      };

      heimdall = {
        hostname = "heimdall";
        profiles.system = {
          sshUser = "root";
          user = "root";
          path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.heimdall;
        };
      };
    };

    homeConfigurations = {
      "ivek" = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {system = "x86_64-linux";};
        modules = [
          ./hosts/server/home.nix
          (
            {...}: {
              home.username = "ivek";
              home.homeDirectory = "/home/ivek";
            }
          )
        ];
        extraSpecialArgs = {inherit inputs;};
      };

      "banir" = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {system = "x86_64-linux";};
        modules = [
          ./hosts/server/home.nix
          (
            {...}: {
              home.username = "banir";
              home.homeDirectory = "/home/banir";
            }
          )
        ];
        extraSpecialArgs = {inherit inputs;};
      };
    };

    nixOnDroidConfigurations.default = nix-on-droid.lib.nixOnDroidConfiguration {
      modules = [inputs.stylix.nixOnDroidModules.stylix ./hosts/andronix/configuration.nix];
      extraSpecialArgs = {inherit inputs;};
      pkgs = import nixpkgs {
        system = "aarch64-linux";
        overlays = [
          nix-on-droid.overlays.default
        ];
      };
    };

    nixosConfigurations = {
      heimdall = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          disko.nixosModules.disko
          ./hosts/heimdall/configuration.nix
          ./modules/servers/general
        ];
      };

      nixos = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs;};
        modules = [
          # Get the system config
          ./hosts/nixos/configuration.nix
          # Enable stylix
          inputs.stylix.nixosModules.stylix
          # Load updated auto-cpufreq
          auto-cpufreq.nixosModules.default
          # Load my modules
          ./modules/linux/nixos
          # Still no specific modules here
          # ./modules/cross-platform/nixos
          # Setup home manager for my user
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.extraSpecialArgs = {inherit inputs;};
            home-manager.backupFileExtension = "backup";
            home-manager.users.crony = {
              imports = [
                ./hosts/nixos/home.nix
                ./modules/linux/home-manager
                ./modules/cross-platform/home-manager
              ];
            };
          }
        ];
      };
    };

    devShells = {
      x86_64-linux.default = let
        system = "x86_64-linux";
        pkgs = nixpkgs.legacyPackages.${system};
      in (import ./shell.nix {inherit pkgs git-hooks;});
      aarch64-linux.default = let
        system = "aarch64-linux";
        pkgs = nixpkgs.legacyPackages.${system};
      in (import ./shell.nix {inherit pkgs git-hooks;});
    };
  };
}
