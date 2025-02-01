{
  config,
  pkgs,
  lib,
  ...
}: {
  options = {
    crony.qemu.enable = lib.mkEnableOption "Enable qemu and setup quickemu";
  };

  config = lib.mkIf config.crony.qemu.enable {
    systemd.tmpfiles.rules = ["L+ /var/lib/qemu/firmware - - - - ${pkgs.qemu}/share/qemu/firmware"];

    environment.systemPackages = with pkgs; [
      qemu
      quickemu
    ];
  };
}
