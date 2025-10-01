{
  config,
  lib,
  pkgs,
  ...
}: {
  virtualisation.oci-containers.containers = {
    factorio = {
      image = "factoriotools/factorio:latest";
      ports = [
        "34197:34197/udp"
        "27015:27015/tcp"
      ];
      volumes = [
        "/persist/factorio/space:/factorio"
      ];
      environment = {
        GENERATE_NEW_SAVE = "false";
        LOAD_LATEST_SAVE = "true";
        UPDATE_MODS_ON_START = "false";
      };
    };
  };

  networking = {
    firewall = {
      allowedTCPPorts = [27015];
      allowedUDPPorts = [34197];
    };
  };

  users.users.factorio = {
    isSystemUser = true;
    uid = 984;
    group = "factorio";
  };
  users.groups.factorio.gid = 984;
}
