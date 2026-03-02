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

    # Secrets repo
    secrets = {
      url = "git+https://git.cronyakatsuki.xyz/crony/nixos-secrets";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.agenix.follows = "agenix";
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
    hyprland.url = "github:hyprwm/Hyprland";

    # Dev version of hyprlock
    hyprlock = {
      url = "github:hyprwm/hyprlock";
    };

    # Pyland for hyprland plugins
    pyprland.url = "github:hyprland-community/pyprland";

    # Hyprland layout per workspace
    hyprWorkspaceLayouts = {
      url = "github:zakk4223/hyprWorkspaceLayouts";
      inputs.hyprland.follows = "hyprland"; # to make sure that the plugin is built for the correct version of hyprland
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

    # Secure boot with nixos
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v1.0.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Cachy os kernel
    nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release";
  };

  outputs = {
    self,
    nixpkgs,
    git-hooks,
    nix-on-droid,
    deploy-rs,
    home-manager,
    ...
  } @ inputs: let
    hostsData = import ./hosts.nix;
    serversOnly = nixpkgs.lib.filterAttrs (n: v: v.type == "server") hostsData;
    mkDeployNode = hostname: arch: {
      inherit hostname;
      profiles.system = {
        sshUser = "root";
        user = "root";
        path = deploy-rs.lib.${arch}.activate.nixos self.nixosConfigurations.${hostname};
      };
    };
    mkHost = name: host: let
      lib = nixpkgs.lib;
      hostModule = ./hosts/${name}/configuration.nix;

      inherit
        (import ./helpers.nix {inherit lib inputs host name;})
        baseModules
        clientDefaults
        serverExtras
        specialModules
        homeManagerModules
        ;

      allModules = lib.concatLists [
        baseModules
        [hostModule]
        host.extraModules or [] # clientExtras stays here
        clientDefaults
        serverExtras
        homeManagerModules
        specialModules
      ];
    in
      nixpkgs.lib.nixosSystem {
        system = host.arch;
        specialArgs = {inherit inputs;};
        modules = allModules;
      };
  in {
    deploy.nodes =
      nixpkgs.lib.mapAttrs' (
        hostname: meta: let
          arch = meta.arch;
        in {
          name = hostname;
          value = mkDeployNode hostname arch;
        }
      )
      serversOnly;

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

    nixosConfigurations =
      nixpkgs.lib.mapAttrs' (name: host: {
        name = name;
        value = mkHost name host;
      })
      hostsData;

    homeConfigurations."crony" = home-manager.lib.homeManagerConfiguration {
      extraSpecialArgs = {inherit inputs;};
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      modules = [./hosts/gentoo/home.nix];
    };

    devShells = {
      x86_64-linux.default = let
        system = "x86_64-linux";
        pkgs = nixpkgs.legacyPackages.${system};
      in (import ./shell.nix {inherit inputs pkgs git-hooks;});
      aarch64-linux.default = let
        system = "aarch64-linux";
        pkgs = nixpkgs.legacyPackages.${system};
      in (import ./shell.nix {inherit inputs pkgs git-hooks;});
    };
  };
}
