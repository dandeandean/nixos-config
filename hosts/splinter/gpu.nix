{
  pkgs,
  ...
}:
{
  config = {
    nixpkgs.config.allowUnfree = true;
    hardware.nvidia = {
      modesetting.enable = true;
      nvidiaSettings = true;
      open = false;
    };
    hardware.graphics.enable = true;
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
