{
  inputs,
  self,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./caddy
    ./immich.nix
  ];
}
