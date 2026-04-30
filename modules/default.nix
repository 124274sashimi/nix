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
    # ./docker
    # ./immich.nix
    ./agenix-cli.nix
    ./ddclient
    ./zfs.nix
    ./minecraft-server.nix
    ./factorio-server.nix
    ./filebrowser
    ./authelia
    ./cuda.nix
    ./beszel.nix
    ./services/my

    ./stacks/beszel-agent.nix
    ./stacks/immich.nix
  ];
}
