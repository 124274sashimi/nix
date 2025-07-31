{
  config,
  lib,
  pkgs,
  ...
}:
{
  services = {
    sanoid = {
      enable = true;
      datasets."zpool/safe" = {
        autosnap = true;
        autoprune = true;
        recursive = true;
        frequently = 8;
        hourly = 24;
        daily = 7;
        weekly = 12;
        monthly = 12;
        yearly = 3;
      };
    };
  };
}
