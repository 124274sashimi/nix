{
  config,
  lib,
  pkgs,
  ...
}:
{
  virtualisation.oci-containers.containers = {
    minecraft = {
      image = "itzg/minecraft-server";
      ports = [
        "25565:25565"
      ];
      volumes = [
        "/persist/minecraft/alyssa:/data"
      ];
      environment = {
        EULA = "TRUE";
        VIEW_DISTANCE = "32";
        SPAWN_PROTECTION = "0";
        ALLOW_FLIGHT = "TRUE";
        INIT_MEMORY = "2G";
        MAX_MEMORY = "12G";
      };
      user = "986:986";
    };
  };

  networking = {
    firewall = {
      allowedTCPPorts = [ 25565 ];
      allowedUDPPorts = [ 25565 ];
    };
  };

  users.users.minecraft = {
    isSystemUser = true;
    uid = 986;
    group = "minecraft";
  };
  users.groups.minecraft.gid = 986;
}
