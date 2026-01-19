{...}: let
  servicesDir = ./services;
  serviceFiles =
    builtins.filter
    (name: builtins.match "^.*\\.nix$" name != null)
    (builtins.attrNames (builtins.readDir servicesDir));
  hostModules = map (fn: import "${servicesDir}/${fn}") serviceFiles;
in {
  imports =
    [
      ../general
      ./secrets.nix
    ]
    ++ hostModules;
}
