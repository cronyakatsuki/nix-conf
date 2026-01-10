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

    # auto-cpufreq latest version, for optimizing my laptop's thermal's
    auto-cpufreq = {
      url = "github:AdnanHodzic/auto-cpufreq";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # use custom nbfc that has the config for my laptop
    nbfc-linux = {
      url = "github:cronyakatsuki/nbfc-linux/a715-41g";
      inputs.nixpkgs.follows = "nixpkgs";
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

    # Support for android
    nix-on-droid = {
      url = "github:nix-community/nix-on-droid/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    # Declare flatpak easilly
    nix-flatpak = {
      url = "github:gmodena/nix-flatpak/?ref=latest";
    };

    # Neovim nightly
    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Deploy-rs
    deploy-rs = {
      url = "github:serokell/deploy-rs";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Disko
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # secrets management
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # My selfhosted service, inspired by 0x0.st
    upfast = {
      url = "git+https://git.cronyakatsuki.xyz/crony/UpFast";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # My note management app
    note = {
      url = "git+https://git.cronyakatsuki.xyz/crony/note";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # My custom script for downloading humble bundle bundle's
    hb-downloader = {
      url = "git+https://git.cronyakatsuki.xyz/crony/hb-downloader";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # My custom script for downloading humble bundle bundle's
    extract-romset = {
      url = "git+https://git.cronyakatsuki.xyz/crony/extract-romset-dat";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # My flake for installing lnxlink
    lnxlink = {
      url = "git+https://git.cronyakatsuki.xyz/crony/lnxlink-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Dev version of hyprland
    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Dev version of hyprlock
    hyprlock = {
      url = "github:hyprwm/hyprlock";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Chaotic repo for some of their packages
    chaotic = {
      url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # AAGL
    aagl.url = "github:ezKEa/aagl-gtk-on-nix";
    aagl.inputs.nixpkgs.follows = "nixpkgs";

    # Emacs, my enemy let me try to learn you again
    emacs-overlay = {
      url = "github:nix-community/emacs-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # zen browser
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Some gaming related stuff ( actual osu! )
    nix-gaming.url = "github:cronyakatsuki/nix-gaming";
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
    nix-flatpak,
    chaotic,
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

      # baldur = {
      #   hostname = "baldur";
      #   profiles.system = {
      #     sshUser = "root";
      #     user = "root";
      #     path = deploy-rs.lib.aarch64-linux.activate.nixos self.nixosConfigurations.baldur;
      #   };
      # };

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

      tyr = {
        hostname = "tyr";
        profiles.system = {
          sshUser = "root";
          user = "root";
          path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.tyr;
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
        specialArgs = {inherit inputs;};
        system = "x86_64-linux";
        modules = [
          disko.nixosModules.disko
          agenix.nixosModules.default
          home-manager.nixosModules.home-manager
          ./hosts/heimdall/configuration.nix
          ./modules/servers/general
          ./modules/servers/heimdall
          ./modules/servers/home-manager
        ];
      };

      # baldur = nixpkgs.lib.nixosSystem {
      #   specialArgs = {inherit inputs;};
      #   system = "aarch64-linux";
      #   modules = [
      #     disko.nixosModules.disko
      #     agenix.nixosModules.default
      #     home-manager.nixosModules.home-manager
      #     ./hosts/baldur/configuration.nix
      #     ./modules/servers/general
      #     ./modules/servers/baldur
      #     ./modules/servers/home-manager
      #   ];
      # };

      bragi = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs;};
        system = "aarch64-linux";
        modules = [
          disko.nixosModules.disko
          agenix.nixosModules.default
          home-manager.nixosModules.home-manager
          ./hosts/bragi/configuration.nix
          ./modules/servers/general
          ./modules/servers/bragi
          ./modules/servers/home-manager
        ];
      };

      thor = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs;};
        system = "aarch64-linux";
        modules = [
          disko.nixosModules.disko
          agenix.nixosModules.default
          home-manager.nixosModules.home-manager
          ./hosts/thor/configuration.nix
          ./modules/servers/general
          ./modules/servers/thor
          ./modules/servers/home-manager
        ];
      };

      odin = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs;};
        system = "aarch64-linux";
        modules = [
          disko.nixosModules.disko
          agenix.nixosModules.default
          home-manager.nixosModules.home-manager
          ./hosts/odin/configuration.nix
          ./modules/servers/general
          ./modules/servers/odin
          ./modules/servers/home-manager
        ];
      };

      freyja = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs;};
        system = "aarch64-linux";
        modules = [
          disko.nixosModules.disko
          agenix.nixosModules.default
          home-manager.nixosModules.home-manager
          ./hosts/freyja/configuration.nix
          ./modules/servers/general
          ./modules/servers/freyja
          ./modules/servers/home-manager
        ];
      };

      tyr = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs;};
        modules = [
          disko.nixosModules.disko
          agenix.nixosModules.default
          inputs.stylix.nixosModules.stylix
          auto-cpufreq.nixosModules.default
          ./hosts/tyr/configuration.nix
          ./modules/linux/nixos
          ./modules/servers/tyr
          ./modules/servers/general/restic.nix
          ./modules/servers/general/podman.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.extraSpecialArgs = {inherit inputs;};
            home-manager.backupFileExtension = "backup";
            home-manager.users.crony = {
              imports = [
                ./modules/linux/home-manager
                ./modules/cross-platform/home-manager
                ./hosts/tyr/home.nix
              ];
            };
          }
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
          # Use flatpak for one package globally
          nix-flatpak.nixosModules.nix-flatpak
          # Use chaotic for some packages
          chaotic.nixosModules.default
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

      skadi = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs;};
        modules = [
          # Get the system config
          ./hosts/skadi/configuration.nix
          # Enable stylix
          inputs.stylix.nixosModules.stylix
          # Enable AAGL
          inputs.aagl.nixosModules.default
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
          # Use flatpak for one package globally
          nix-flatpak.nixosModules.nix-flatpak
          # Use chaotic for some packages
          chaotic.nixosModules.default
          # Setup home manager for my user
          home-manager.nixosModules.home-manager
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
