{
  config,
  pkgs,
  lib,
  ...
}: let
  opts = {
    paths = [
      # "/home/crony/.face"
      "/home/crony/.config/zen"
      # Zen flatpak profile (chrome css is in ~/dotfiles, but bookmarks/history/sessions live here)
      "/home/crony/.var/app/app.zen_browser.zen/.zen"
      "/home/crony/.thunderbird"
      "/home/crony/.ssh"
      "/home/crony/docs/sync"
      # "/home/crony/docs/wireguard-keys"
      "/home/crony/pic"
      "/home/crony/org"
      # ES-DE (ROMs) moved to NAS (/mnt/share/roms/ES-DE), removed from restic 2026-10-20
      # Game saves & emulator data
      "/home/crony/.config/retroarch"
      "/home/crony/.config/rpcs3"
      "/home/crony/.config/dolphin-emu"
      "/home/crony/.local/share/dolphin-emu"
      "/home/crony/.local/share/Steam/userdata"
      "/home/crony/.local/share/Steam/steamapps/compatdata"
      "/home/crony/.local/share/atuin"
      "/home/crony/.local/share/Xenia"
      "/home/crony/.local/share/PrismLauncher"
      "/home/crony/.local/share/osu"
      "/home/crony/.config/obs-studio"
      "/home/crony/.local/share/easyeffects"
      "/home/crony/.pi"
    ];
    excludes = [
      # npm = node_modules of installed pi extensions, regenerable via just pi-extensions
      "/home/crony/.pi/agent/npm"
      # stow-managed from ~/dotfiles/pi, version-controlled
      "/home/crony/.pi/agent/extensions"
      "/home/crony/.pi/agent/tmp"
      "/home/crony/.pi/agent/logs"
      # zen flatpak caches (regenerable)
      "/home/crony/.var/app/app.zen_browser.zen/.zen/main/cache2"
      "/home/crony/.var/app/app.zen_browser.zen/.zen/main/startupCache"
      "/home/crony/.var/app/app.zen_browser.zen/.zen/main/shader-cache"
    ];
    pruneOpts = [
      "--keep-last 10"
      "--keep-daily 7"
      "--keep-weekly 5"
      "--keep-monthly 12"
    ];
    checkOpts = [
      "--read-data-subset=10%"
      "--with-cache"
    ];
  };
in {
  options = {
    crony.restic.enable = lib.mkEnableOption "Install and setup restic and backup services.";
  };

  config = lib.mkIf config.crony.restic.enable {
    # Restic home manager service
    services.restic = {
      enable = true;
      backups = {
        local = {
          initialize = true;
          passwordFile = "/run/user/1000/agenix/restic-local-pass";
          repository = "/mnt/backup";
          paths = opts.paths;
          exclude = opts.excludes;
          pruneOpts = opts.pruneOpts;
          checkOpts = opts.checkOpts;
        };
        nas = {
          initialize = true;
          passwordFile = "/run/user/1000/agenix/restic-local-pass";
          repository = "/mnt/share/backup";
          paths = opts.paths;
          exclude = opts.excludes;
          pruneOpts = opts.pruneOpts;
          checkOpts = opts.checkOpts;
        };
        backblaze = {
          initialize = true;
          passwordFile = "/run/user/1000/agenix/restic-backblaze-pass";
          repositoryFile = "/run/user/1000/agenix/restic-backblaze-repo";
          environmentFile = "/run/user/1000/agenix/restic-backblaze-env";
          paths = opts.paths;
          exclude = opts.excludes;
          pruneOpts = opts.pruneOpts;
          checkOpts = opts.checkOpts;
        };
      };
    };
  };
}
