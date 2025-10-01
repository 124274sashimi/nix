{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:
{
  users.users.authelia-main.uid = 985;
  users.users.authelia-main.group = "authelia-main";
  users.groups.authelia-main.gid = 985;

  age.secrets.authelia-jwt-secret = {
    file = ../../secrets/authelia-jwt-secret.age;
    owner = "authelia-main";
    group = "authelia-main";
  };
  age.secrets.authelia-session-secret = {
    file = ../../secrets/authelia-session-secret.age;
    owner = "authelia-main";
    group = "authelia-main";
  };
  age.secrets.authelia-storage-encryption-key = {
    file = ../../secrets/authelia-storage-encryption-key.age;
    owner = "authelia-main";
    group = "authelia-main";
  };

  containers.authelia = {
    autoStart = true;
    privateNetwork = true;
    hostAddress = "192.168.100.15";
    localAddress = "192.168.100.16";

    bindMounts = {
      "${config.age.secrets.authelia-jwt-secret.path}".isReadOnly = true;
      "${config.age.secrets.authelia-session-secret.path}".isReadOnly = true;
      "${config.age.secrets.authelia-storage-encryption-key.path}".isReadOnly = true;
      # "/var/lib/authelia-main" = {
      #   hostPath = "/persist/authelia";
      #   isReadOnly = false;
      # };
      # "/var/lib/redis-redis-authelia" = {
      #   hostPath = "/persist/authelia/redis";
      #   isReadOnly = false;
      # };
    };

    config =
      let
        hostConfig = config;
      in
      {
        config,
        pkgs,
        ...
      }:
      {
        system.stateVersion = "25.05";

        environment.etc."authelia-main/config.yml".source = ./authelia.yml;

        services.authelia.instances = {
          main = {
            enable = true;
            secrets = {
              jwtSecretFile = hostConfig.age.secrets.authelia-jwt-secret.path;
              sessionSecretFile = hostConfig.age.secrets.authelia-session-secret.path;
              storageEncryptionKeyFile = hostConfig.age.secrets.authelia-storage-encryption-key.path;
            };
            settingsFiles = ["/etc/authelia-main/config.yml"];
          };
        };

        services.redis.servers."redis-authelia" = {
          # openFirewall = true;
          enable = true;
          port = 6379;
        };

        users.users.authelia-main.uid = hostConfig.users.users.authelia-main.uid;
        users.users.authelia-main.group = "authelia-main";
        users.groups.authelia-main.gid = hostConfig.users.groups.authelia-main.gid;

      };


  };
}
