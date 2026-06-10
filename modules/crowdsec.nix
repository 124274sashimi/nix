{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:
{
  services.crowdsec = {
    enable = true;
    # settings.console.tokenFile = config.age.secrets.crowdsec-enrollment-key.path;
    settings = {
      api.server = {
        listen_uri = "localhost:8081";
      };
    };
  };


  age.secrets.crowdsec-enrollment-key.file = ../secrets/crowdsec-enrollment-key.age;
}
