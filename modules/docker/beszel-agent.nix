{ pkgs, config, ... }:
let
  dir = "stacks/beszel-agent";
in
{
  environment.etc."${dir}/docker-compose.yaml".source = ./beszel-agent.yaml;

  systemd.services.beszel-agent = {
    wantedBy = [ "multi-user.target" ];
    after = [
      "podman.service"
      "podman.socket"
    ];
    path = [ pkgs.docker ];
    script = ''
      echo $SHELL
      docker compose -f /etc/${dir}/docker-compose.yaml up
    '';
    restartTriggers = [
      config.environment.etc."${dir}/docker-compose.yaml".source
    ];
  };
}
