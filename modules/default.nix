{
  inputs,
  self,
  pkgs,
  lib,
  ...
}:
{
  imports = [
    # Core
    ./zfs.nix
    ./cuda.nix
    ./agenix-cli.nix

    # Networking
    ./caddy
    ./ddclient

    # Services
    ./authelia
    ./beszel.nix
    ./filebrowser
    ./minecraft-server.nix
    ./factorio-server.nix

    # Containers
    ./services/my
    ./stacks/beszel-agent.nix
    ./stacks/immich.nix
  ];
}
