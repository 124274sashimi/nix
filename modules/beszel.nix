{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let 
  unstable = import inputs.nixpkgs-unstable {
    inherit (pkgs.stdenv.hostPlatform) system;
  };
in
{
  disabledModules = [ "services/monitoring/beszel-hub.nix" ];
  imports = [ "${inputs.nixpkgs-unstable}/nixos/modules/services/monitoring/beszel-hub.nix" ];

  services.beszel.hub = {
    enable = true;
    port = 3002;
    package = unstable.beszel;
  };
}
