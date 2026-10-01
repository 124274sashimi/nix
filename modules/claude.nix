{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let 
  unstable = import inputs.nixpkgs-unstable {
    inherit (pkgs.stdenv.hostPlatform) system;

    config = pkgs.config;
  };
in
{
  environment.systemPackages = [ unstable.claude-code ];
}

