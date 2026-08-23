{
  pkgs,
  lib,
  config,
  ...
}:
{
  config = {
    nixpkgs.config.allowUnfree = true;
    # https://community.frame.work/t/egpu-gtx-1060-6gb-working-great-on-nixos-on-the-12th-gen-framework/40919
    hardware.nvidia = {
      modesetting.enable = true;
      powerManagement.enable = false;
      powerManagement.finegrained = false;
      nvidiaSettings = true;
      open = false;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
    };
    # Need this even though we aren't using xserver
    services.xserver.videoDrivers = [ "nvidia" ];
    # Open GL settings
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };
    # https://www.youtube.com/watch?v=5T52jNXzqIU
    nixpkgs.config.allowUnfreePredicate =
      pkg:
      builtins.elem (lib.getName pkg) [
        "nvidia-x11"
        "nvidia-settings"
        "cuda_cudart"
        "libcublas"
        "cuda_cccl"
        "cuda_nvcc"
      ];
    services.ollama = {
      enable = true;
      package = pkgs.ollama-cuda;
      host = "0.0.0.0";
      port = 11434;
      loadModels = [
        "llama3.2:3b"
        "qwen3:1.7b"
      ];
    };
  };
}
