{
  config,
  lib,
  pkgs,
  ...
}:
{
  services = {
    zfs.autoScrub.enable = true;
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
      datasets."backup" = {
        autoprune = true;
        recursive = true;
        frequently = 0;
        hourly = 72;
        daily = 90;
        monthly = 24;
        yearly = 5;

        ### don't take new snapshots - snapshots on backup
        ### datasets are replicated in from source, not
        ### generated locally
        autosnap = false;

        ### monitor hourlies and dailies, but don't warn or
        ### crit until they're over 48h old, since replication
        ### is typically daily only
        hourly_warn = 2880;
        hourly_crit = 3600;
        daily_warn = 48;
        daily_crit = 60;
      };
      datasets."zpool/scratch" = {
        autosnap = true;
        autoprune = true;
        recursive = true;
        daily = 14;
      };
    };
    syncoid = {
      enable = true;
      commonArgs = [ "--no-sync-snap" ];
      commands."backup" = {
        source = "zpool/safe";
        target = "backup/safe";
        recursive = true;
      };
    };
  };
}
