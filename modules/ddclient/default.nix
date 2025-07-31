{
  config,
  lib,
  pkgs,
  ...
}:
let
  configFile = ./ddclient.conf;
in
{
  services.ddclient = {
    enable = true;
    inherit configFile;
  };

  systemd.services.ddclient.serviceConfig.ExecStartPre =
    let
      # https://github.com/NixOS/nixpkgs/blob/nixos-25.05/nixos/modules/services/networking/ddclient.nix#L10
      dataDir = "/var/lib/ddclient";
      RuntimeDirectory = builtins.baseNameOf dataDir;
      preStart = ''
        install --mode=600 --owner=$USER ${configFile} /run/${RuntimeDirectory}/ddclient.conf
        "${pkgs.replace-secret}/bin/replace-secret" "@porkbun-api-key@" "${config.age.secrets.porkbun-api-key.path}" "/run/${RuntimeDirectory}/ddclient.conf"
        "${pkgs.replace-secret}/bin/replace-secret" "@porkbun-secret-key@" "${config.age.secrets.porkbun-secret-key.path}" "/run/${RuntimeDirectory}/ddclient.conf"
      '';
    in
    [ "!${pkgs.writeShellScript "ddclient-prestart-secrets" preStart}" ];

  age.secrets.porkbun-api-key.file = ../../secrets/porkbun-api-key.age;
  age.secrets.porkbun-secret-key.file = ../../secrets/porkbun-secret-key.age;
}
