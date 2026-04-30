{ config, ... }:
let
  my = config.services.my.beszel-agent;
in
{
  services.my.beszel-agent = {
    stack = {
      enable = true;
      security.enable = true;
      security.readOnlyRootFilesystem = false; # Required to use gpu

      containers = {
        beszel-agent = {
          containerConfig = {
            image = "henrygd/beszel-agent-nvidia:0.18.7";
            volumes = [
              "/etc/stacks/beszel-agent/beszel_agent_data:/var/lib/beszel-agent"
              # Expose podman socket to monitor containers
              "/run/podman/podman.sock:/run/podman/podman.sock:ro"
            ];
            environments = {
              LISTEN = "45886";
              KEY = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM/NoIbUJQmV3sGbSVmNyZpg/BPZ7AY8OiRi63Le30a8";
              DOCKER_HOST = "unix:///run/podman/podman.sock";
              GPU_COLLECTOR = "nvidia-smi";
              NICS = "enp*";
            };
            networks = [ "host" ];
            podmanArgs = [
              "--gpus=all"
            ];
            healthCmd = "/agent health";
            healthInterval = "30s";
            healthTimeout = "10s";
            healthRetries = 3;
            healthStartPeriod = "30s";
          };
        };
      };
    };
  };
}
