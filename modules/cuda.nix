{
  self,
  inputs,
  lib,
  pkgs,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    linuxPackages.nvidia_x11
    cudaPackages.cuda_nvcc
    cudaPackages.cudatoolkit

    python3Packages.pytorch
    python3Packages.torchvision
    python3Packages.torchaudio

    python3Packages.cupy

    # ct

    python3Packages.jupyterlab
    python3Packages.ipykernel
    python3Packages.ipywidgets
    python3Packages.matplotlib
    python3Packages.numpy
    python3Packages.pandas

    pkg-config

  ];
  # __structuredAttrs = true;
  # strictDeps = true;
  environment.sessionVariables =
    let
      ct = pkgs.cudaPackages.cudatoolkit;
    in
    {
      CUDA_HOME = ct;
      CUDA_PATH = ct;
      PATH = "${ct}/bin";
      LD_LIBRARY_PATH = "${ct}/lib:${ct.lib}/lib";
      # LD_LIBRARY_PATH = '/run/opengl-driver/lib:/run/opengl-driver-32/lib:${ct}/lib:${ct.lib}/lib'
      # LD_LIBRARY_PATH = '/run/opengl-driver/lib:/run/opengl-driver-32/lib:${ct}/lib:${ct.lib}/lib'
    };
}
