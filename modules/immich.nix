{
  config,
  lib,
  pkgs,
  ...
}:
{
  containers.immich = {
    autoStart = true;
    privateNetwork = true;
    hostAddress = "192.168.100.5";
    localAddress = "192.168.100.6";
    bindMounts = {
      "/var/lib/immich" = {
        hostPath = "/persist/immich";
        isReadOnly = false;
      };

      # config container dns
      "/etc/resolv.conf" = {
        hostPath = "/etc/resolv.conf";
        isReadOnly = true;
      };

      #
      #      "/var/lib/postgresql/${config.services.postgresql.package.psqlSchema}" = {
      #      	hostPath = "/persist/immich-db";
      # isReadOnly = false;
      #      };
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
        networking.useHostResolvConf = lib.mkForce false;
        system.stateVersion = "25.05";

        services.immich = {
          enable = true;
          mediaLocation = "/var/lib/immich";
          openFirewall = true;
          host = "0.0.0.0"; # within the container

          environment = {
            TZ = "PDT";
            # DB_PASSWORD="Uf9PuxpYzaUNaGgU";
          };

        };

        users.users.immich.uid = hostConfig.users.users.immich.uid;
        users.groups.immich.gid = hostConfig.users.groups.immich.gid;
      };
  };

  users.users.immich.uid = 988;
  users.users.immich.group = "immich";
  users.groups.immich.gid = 988;
}
