{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.crowdsec;
  stateDir = "/var/lib/crowdsec/state";
in
{
  services.crowdsec = {
    enable = true;
    autoUpdateService = true;

    hub.collections = [
      "crowdsecurity/linux" # sshd, base whitelists (private IP ranges)
      "crowdsecurity/caddy"
      "crowdsecurity/base-http-scenarios"
      "crowdsecurity/http-cve"
    ];

    localConfig.acquisitions = [
      {
        source = "journalctl";
        journalctl_filter = [ "_SYSTEMD_UNIT=sshd.service" ];
        labels.type = "syslog";
      }
      {
        source = "file";
        filenames = [ "/var/log/caddy/*.log" ];
        labels.type = "caddy";
      }
    ];

    # The module only fills in a default for `profiles`; keeping the default bans.

    settings = {
      # Everything that goes into config.yaml lives under `general`.
      general.api.server = {
        enable = true; # the module defaults the local API to off
        listen_uri = "127.0.0.1:8081";
      };
      # Without these the credentials paths are null and setup fails.
      lapi.credentialsFile = "${stateDir}/local_api_credentials.yaml";
      capi.credentialsFile = "${stateDir}/online_api_credentials.yaml";
    };
  };

  # The register unit's DynamicUser + StateDirectory moves /var/lib/crowdsec
  # into /var/lib/private (root-only), locking out crowdsec.service and cscli.
  # A static crowdsec user exists, so run everything as that instead.
  systemd.services = lib.mkMerge [
    (lib.genAttrs [ "crowdsec" "crowdsec-update-hub" "crowdsec-firewall-bouncer-register" ] (_: {
      serviceConfig = {
        DynamicUser = lib.mkForce false;
        StateDirectory = lib.mkDefault "crowdsec";
      };
    }))

    # Read Caddy's access logs.
    { crowdsec.serviceConfig.SupplementaryGroups = [ config.services.caddy.group ]; }

    {
      # Runs as root before crowdsec: reclaims files left owned by the old
      # dynamic UID and gets the credentials files into a state the setup script accepts.
      crowdsec-init = {
        description = "Prepare CrowdSec state directory";
        wantedBy = [ "crowdsec.service" ];
        before = [ "crowdsec.service" ];
        serviceConfig.Type = "oneshot";
        script =
          let
            lapi = cfg.settings.lapi.credentialsFile;
            capi = cfg.settings.capi.credentialsFile;
            cscli = "${pkgs.util-linux}/bin/runuser -u ${cfg.user} -- ${lib.getExe' cfg.package "cscli"} -c /etc/crowdsec/config.yaml";
          in
          ''
            install -d -o ${cfg.user} -g ${cfg.group} -m 0750 ${stateDir}
            chown -R ${cfg.user}:${cfg.group} /var/lib/crowdsec

            # cscli won't load the LAPI unless this file exists; `capi register` fills it.
            [ -e ${capi} ] || install -o ${cfg.user} -g ${cfg.group} -m 0600 /dev/null ${capi}

            # The setup script runs `machines add` only when this file is empty, and
            # that command refuses to overwrite an existing file. Remove an empty one,
            # plus any half-registered machine of the same name, so it can start over.
            if [ -e ${lapi} ] && [ ! -s ${lapi} ]; then
              rm -f ${lapi}
              ${cscli} machines delete ${lib.escapeShellArg cfg.name} || true
            fi
          '';
      };
    }
  ];

  # crowdsec-firewall-bouncer-register calls cscli without `-c`, so cscli
  # looks for /etc/crowdsec/config.yaml, which the crowdsec module never writes.
  # This generates the same store path the module passes to `-c`.
  environment.etc."crowdsec/config.yaml".source =
    (pkgs.formats.yaml { }).generate "crowdsec.yaml" cfg.settings.general;

  services.crowdsec-firewall-bouncer = {
    enable = true;
    # registerBouncer.enable defaults to true when services.crowdsec is enabled;
    # mode defaults to iptables since networking.nftables is off.
  };

  age.secrets.crowdsec-enrollment-key = {
    file = ../secrets/crowdsec-enrollment-key.age;
    owner = cfg.user;
  };
}

