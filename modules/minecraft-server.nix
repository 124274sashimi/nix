{
  config,
  lib,
  pkgs,
  ...
}: {
  virtualisation.oci-containers.containers = {
    minecraft = {
      image = "itzy/minecraft-server";
      ports = [
        "25567:25565"
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
    };
  };

  networking = {
    firewall = {
      allowedTCPPorts = [25565];
      allowedUDPPorts = [25565];
    };
  };
}
