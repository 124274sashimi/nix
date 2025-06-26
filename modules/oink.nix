{
  config,
  lib,
  pkgs,
  ...
}: {
  systemd.services.oink = {
    description = "Dynamic DNS client for Porkbun";
    after = ["network.target"];
    wantedBy = ["multi-user.target"];
    script = "${pkgs.oink}/bin/oink -c /etc/oink_ddns/config.json";
  };

  environment.etc = {
    "oink_ddns/config.json".text = ''
      {
        "global": {
          "secretapikey": "@porkbun-secret-key@",
          "apikey": "@porkbun-api-key@",
          "interval": 900,
          "ttl": 600
        },
        "domains": [
          {
            "domain": "sashimii.com",
            "subdomain": ""
          },
          {
            "domain": "sashimii.com",
            "subdomain": "*"
          }
        ]
      }
    '';
  };

  # We use agenix so we need to create the config at activation time.
  system.activationScripts."porkbun-secrets" = lib.stringAfter ["etc" "agenix"] ''
    apiKey=$(cat "${config.age.secrets."porkbun-api-key".path}")
    secretKey=$(cat "${config.age.secrets."porkbun-secret-key".path}")
    configDir=/etc/oink_ddns
    mkdir -p "$configDir"
    configFile=$configDir/config.json
    ${pkgs.gnused}/bin/sed -i "s#@porkbun-api-key@#$apiKey#" "$configFile"
    ${pkgs.gnused}/bin/sed -i "s#@porkbun-secret-key@#$secretKey#" "$configFile"
  '';

  age.secrets.porkbun-api-key.file = ../secrets/porkbun-api-key.age;
  age.secrets.porkbun-secret-key.file = ../secrets/porkbun-secret-key.age;

  networking.firewall.allowedTCPPorts = [
    80
    443
  ];
}
