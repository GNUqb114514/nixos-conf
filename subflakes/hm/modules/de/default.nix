{ pkgs, lib, config, ... }:
{
  config = {
    home.packages = with pkgs; [
      # Launcher
      fuzzel
      swaylock
    ];
    services.swayosd.enable = true;
  };
  imports = [
    ./waybar.nix
    ./idle.nix
  ];
}
