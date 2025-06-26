{
  self,
  inputs,
  lib,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    inputs.agenix.packages."${system}".default
  ];
}
