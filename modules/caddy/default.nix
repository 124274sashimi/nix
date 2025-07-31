{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:
{
  services.caddy = {
    enable = true;
    configFile = ./Caddyfile;
  };

  networking.firewall.allowedTCPPorts = [
    80
    443
  ];
}
