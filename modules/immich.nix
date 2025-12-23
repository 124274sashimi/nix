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

      # "/dev/dri" = {
      #   hostPath = "/dev/dri";
      #   isReadOnly = false;
      # };
      #
      #
      #      "/var/lib/postgresql/${config.services.postgresql.package.psqlSchema}" = {
      #      	hostPath = "/persist/immich-db";
      # isReadOnly = false;
      #      };
    };
    # allowedDevices = [
    #   {
    #     modifier = "rwm";
    #     node = "/dev/dri";
    #   }
    # ];
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
        environment.systemPackages = with pkgs; [
          mesa-demos
          nvidia-container-toolkit
          # immich-machine-learning
        ];

        nixpkgs.config.allowUnfree = true;
        services.xserver.videoDrivers = [ "nvidia" ];
        hardware = {
          graphics.enable = true;
          # nvidia = hostConfig.hardware.nvidia;
        };
        hardware.nvidia = {

          # Modesetting is required.
          modesetting.enable = true;

          # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
          # Enable this if you have graphical corruption issues or application crashes after waking
          # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead
          # of just the bare essentials.
          powerManagement.enable = false;

          # Fine-grained power management. Turns off GPU when not in use.
          # Experimental and only works on modern Nvidia GPUs (Turing or newer).
          powerManagement.finegrained = false;

          # Use the NVidia open source kernel module (not to be confused with the
          # independent third-party "nouveau" open source driver).
          # Support is limited to the Turing and later architectures. Full list of
          # supported GPUs is at:
          # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus
          # Only available from driver 515.43.04+
          open = false;

          # Enable the Nvidia settings menu,
          # accessible via `nvidia-settings`.
          nvidiaSettings = true;

          # Optionally, you may need to select the appropriate driver version for your specific GPU.
          package = config.boot.kernelPackages.nvidiaPackages.stable;
        };

        hardware.nvidia-container-toolkit.enable = true;

        # hardware = hostConfig.hardware;

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

          machine-learning = {
            enable = true;
          };
          accelerationDevices = null;

        };

        users.users.immich.uid = hostConfig.users.users.immich.uid;
        users.groups.immich.gid = hostConfig.users.groups.immich.gid;
      };
  };

  users.users.immich.uid = 988;
  users.users.immich.group = "immich";
  users.groups.immich.gid = 988;
}
