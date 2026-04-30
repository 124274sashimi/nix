{
  self,
  inputs,
  lib,
  pkgs,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    nvidia-container-toolkit
    cudaPackages.cudatoolkit
  ];

  # https://discourse.nixos.org/t/importerror-libstdc-so-6-cannot-open-shared-object-file-no-such-file-or-directory/41988/4
  environment.variables.LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath [
    pkgs.stdenv.cc.cc
    pkgs.cudaPackages.cudatoolkit
    pkgs.cudaPackages.cudnn
  ];

}
