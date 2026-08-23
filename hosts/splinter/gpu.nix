{
  pkgs,
  lib,
  ...
}:
{
  config = {
    nixpkgs.config.allowUnfree = true;
    hardware.nvidia = {
      modesetting.enable = true;
      nvidiaSettings = false;
      open = false;
    };
    # Need this even though we aren't using xserver
    services.xserver.videoDrivers = [ "nvidia" ];
    hardware.graphics.enable = true;
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
