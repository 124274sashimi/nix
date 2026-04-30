{ config, ... }:
let
  my = config.services.my.immich;
in
{
  services.my.immich = {
    stack = {
      enable = true;
      network.enable = true;
      security.enable = false;

      containers = {
        server = {
          containerConfig = {
            image = "ghcr.io/immich-app/immich-server:v2.7.5";
            publishPorts = [ "127.0.0.1:2383:2283" ];
            volumes = [
              "/etc/localtime:/etc/localtime:ro"
              "/persist/immich:/data"
            ];
            environmentFiles = [ config.age.secrets.immich-env.path ];
          };

          dependsOn = [
            "redis"
            "database"
          ];
        };

        machine-learning = {
          containerConfig = {
            image = "ghcr.io/immich-app/immich-machine-learning:v2.7.5-cuda";
            volumes = [ "/scratch/immich-model-cache:/cache" ];
            networkAliases = [ "machine-learning" ];
            podmanArgs = [
              "--gpus=all"
            ];
          };
        };

        redis = {
          containerConfig = {
            image = "docker.io/valkey/valkey:9@sha256:3b55fbaa0cd93cf0d9d961f405e4dfcc70efe325e2d84da207a0a8e6d8fde4f9";
            healthCmd = "redis-cli ping || exit 1";
            networkAliases = [ "redis" ];
            notify = "healthy";
          };
        };

        database = {
          containerConfig = {
            image = "ghcr.io/immich-app/postgres:14-vectorchord0.4.3-pgvectors0.2.0@sha256:bcf63357191b76a916ae5eb93464d65c07511da41e3bf7a8416db519b40b1c23";
            environmentFiles = [ config.age.secrets.immich-env.path ];
            environments = {
              POSTGRES_INITDB_ARGS = "--data-checksums";
            };
            securityLabelDisable = true;
            volumes = [
              "/scratch/immich-db:/var/lib/postgresql/data:z"
            ];
            networkAliases = [ "database" ];
          };
        };

      };
    };
  };

  age.secrets.immich-env.file = ../../secrets/immich-env.age;
}
