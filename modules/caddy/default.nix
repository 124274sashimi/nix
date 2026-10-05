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
    # CrowdSec bouncer: `appsec` sends requests to the CrowdSec AppSec component.
    # The module root pulls in all its handlers (http, appsec, layer4); listing
    # it rather than the subpackages lets withPlugins' install check find it.
    package = pkgs.caddy.withPlugins {
      plugins = [ "github.com/hslatman/caddy-crowdsec-bouncer@v0.14.1" ];
      hash = "sha256-RKkwa4/q0+EwEB8+Ik/gb7SuNWKYuV445UqSDK4MDac=";
    };
    configFile = ./Caddyfile;
  };

  # Exposes custom build to CLI
  environment.systemPackages = [ config.services.caddy.package ];

  networking.firewall.allowedTCPPorts = [
    80
    443
  ];
}
