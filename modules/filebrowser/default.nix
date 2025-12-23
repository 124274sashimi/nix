{
  config,
  lib,
  pkgs,
  ...
}:
{
  virtualisation.oci-containers.containers = {
    filebrowser-test-h =
      let
        configFile = ./config.yaml;
      in
      {
        image = "gtstef/filebrowser";
        ports = [ "2284:2284" ];
        volumes = [
          # Data
          "/scratch/filebrowser/bulk:/bulk"
          "/persist/filebrowser/data:/data"
          # Necessary files
          "/scratch/filebrowser/tmp:/home/filebrowser/tmp"
          "/persist/filebrowser/database.db:/database.db"
          "/persist/filebrowser/database.db.bak:/database.db.bak"
          "${configFile}:/config.yaml"
        ];
        environment = {
          FILEBROWSER_CONFIG = "/config.yaml";
          FILEBROWSER_DATABASE = "/database.db";
          # FILEBROWSER_ADMIN_PASSWORD = "REMOVE_AFTER_CONFIG";
          TZ = "America/Los_Angeles";
        };
        user = "987:987";
      };
  };

  # Create a new user to run the service as instead of running as root
  users.users.filebrowser = {
    isSystemUser = true;
    uid = 987;
    group = "filebrowser";
  };
  users.groups.filebrowser.gid = 987;
}
