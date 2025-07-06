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
    ./agenix-cli.nix
    ./oink.nix
    ./zfs.nix
  ];
}
