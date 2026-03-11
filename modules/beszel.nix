{
  config,
  lib,
  pkgs,
  ...
}:
{
  services.beszel.hub = {
    enable = true;
    port = 3002;
  };
}
