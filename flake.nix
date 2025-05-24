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

    # secrets management
    agenix.url = "github:ryantm/agenix";

    # My selfhosted service, inspired by 0x0.st
    upfast.url = "git+https://git.cronyakatsuki.xyz/crony/UpFast";
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
    agenix,
    ...
  } @ inputs: {
    deploy.nodes = {
      heimdall = {
        hostname = "heimdall";
        profiles.system = {
          sshUser = "root";
          user = "root";
          path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.heimdall;
        };
      };

      loki = {
        hostname = "loki";
        profiles.system = {
          sshUser = "root";
          user = "root";
          path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.loki;
        };
      };

      baldur = {
        hostname = "baldur";
        profiles.system = {
          sshUser = "root";
          user = "root";
          path = deploy-rs.lib.aarch64-linux.activate.nixos self.nixosConfigurations.baldur;
        };
      };

      bragi = {
        hostname = "bragi";
        profiles.system = {
          sshUser = "root";
          user = "root";
          path = deploy-rs.lib.aarch64-linux.activate.nixos self.nixosConfigurations.bragi;
        };
      };

      thor = {
        hostname = "thor";
        profiles.system = {
          sshUser = "root";
          user = "root";
          path = deploy-rs.lib.aarch64-linux.activate.nixos self.nixosConfigurations.thor;
        };
      };

      odin = {
        hostname = "odin";
        profiles.system = {
          sshUser = "root";
          user = "root";
          path = deploy-rs.lib.aarch64-linux.activate.nixos self.nixosConfigurations.odin;
        };
      };

      freyja = {
        hostname = "freyja";
        profiles.system = {
          sshUser = "root";
          user = "root";
          path = deploy-rs.lib.aarch64-linux.activate.nixos self.nixosConfigurations.freyja;
        };
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
          agenix.nixosModules.default
          ./hosts/heimdall/configuration.nix
          ./modules/servers/general
          ./modules/servers/heimdall
        ];
      };

      loki = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          disko.nixosModules.disko
          agenix.nixosModules.default
          ./hosts/loki/configuration.nix
          ./modules/servers/general
          ./modules/servers/loki
        ];
      };

      baldur = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        modules = [
          disko.nixosModules.disko
          agenix.nixosModules.default
          ./hosts/baldur/configuration.nix
          ./modules/servers/general
          ./modules/servers/baldur
        ];
      };

      bragi = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        modules = [
          disko.nixosModules.disko
          agenix.nixosModules.default
          ./hosts/bragi/configuration.nix
          ./modules/servers/general
          ./modules/servers/bragi
        ];
      };

      thor = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        modules = [
          disko.nixosModules.disko
          agenix.nixosModules.default
          ./hosts/thor/configuration.nix
          ./modules/servers/general
          ./modules/servers/thor
        ];
      };

      odin = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs;};
        system = "aarch64-linux";
        modules = [
          disko.nixosModules.disko
          agenix.nixosModules.default
          ./hosts/odin/configuration.nix
          ./modules/servers/general
          ./modules/servers/odin
        ];
      };

      freyja = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs;};
        system = "aarch64-linux";
        modules = [
          disko.nixosModules.disko
          agenix.nixosModules.default
          ./hosts/freyja/configuration.nix
          ./modules/servers/general
          ./modules/servers/freyja
        ];
      };

      ymir = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs;};
        modules = [
          # Get the system config
          ./hosts/ymir/configuration.nix
          # Enable stylix
          inputs.stylix.nixosModules.stylix
          # Load updated auto-cpufreq
          auto-cpufreq.nixosModules.default
          # Load my modules
          ./modules/linux/nixos
          # Still no specific modules here
          # ./modules/cross-platform/nixos
          # Use agenix for secrets
          agenix.nixosModules.default
          # Use disko for creating filesystem
          disko.nixosModules.disko
          # Setup home manager for my user
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.extraSpecialArgs = {inherit inputs;};
            home-manager.backupFileExtension = "backup";
            home-manager.users.crony = {
              imports = [
                ./hosts/ymir/home.nix
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
