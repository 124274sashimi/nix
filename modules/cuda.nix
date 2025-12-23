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

  # environment.variables.LD_LIBRARY_PATH = pkgs.stdenv.cc.cc.lib;
  # https://discourse.nixos.org/t/importerror-libstdc-so-6-cannot-open-shared-object-file-no-such-file-or-directory/41988/4
  environment.variables.LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath [
      pkgs.stdenv.cc.cc
      pkgs.cudaPackages.cudatoolkit
      pkgs.cudaPackages.cudnn
  ];

  # shellHook = ''
  #   # fixes libstdc++ issues and libgl.so issues
  #   LD_LIBRARY_PATH=${pkgs.stdenv.cc.cc.lib}/lib/:/run/opengl-driver/lib/
  # '';



  # environment.systemPackages = with pkgs; [
  #   linuxPackages.nvidia_x11
  #   cudaPackages.cuda_nvcc
  #   cudaPackages.cudatoolkit
  #
  #   python3Packages.pytorch
  #   python3Packages.torchvision
  #   python3Packages.torchaudio
  #
  #   python3Packages.cupy
  #
  #   # ct
  #
  #   python3Packages.jupyterlab
  #   python3Packages.ipykernel
  #   python3Packages.ipywidgets
  #   python3Packages.matplotlib
  #   python3Packages.numpy
  #   python3Packages.pandas
  #
  #   pkg-config
  #
  # ];
  # # __structuredAttrs = true;
  # # strictDeps = true;
  # environment.sessionVariables =
  #   let
  #     ct = pkgs.cudaPackages.cudatoolkit;
  #   in
  #   {
  #     CUDA_HOME = ct;
  #     CUDA_PATH = ct;
  #     PATH = "${ct}/bin";
  #     LD_LIBRARY_PATH = "${ct}/lib:${ct.lib}/lib";
  #     # LD_LIBRARY_PATH = '/run/opengl-driver/lib:/run/opengl-driver-32/lib:${ct}/lib:${ct.lib}/lib'
  #     # LD_LIBRARY_PATH = '/run/opengl-driver/lib:/run/opengl-driver-32/lib:${ct}/lib:${ct.lib}/lib'
  #   };
}
