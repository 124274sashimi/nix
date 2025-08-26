{
  inputs,
  self,
  pkgs,
  lib,
  ...
}:
{
  imports = [
    ./caddy
    ./immich.nix
    ./agenix-cli.nix
    ./ddclient
    ./zfs.nix
    ./minecraft-server.nix
    ./filebrowser
    # ./cuda.nix
  ];
}
