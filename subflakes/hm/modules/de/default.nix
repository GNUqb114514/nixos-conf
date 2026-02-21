{ pkgs, ... }:
{
  config = {
    home.packages = with pkgs; [
      # Launcher
      fuzzel
    ];
    services.swayosd.enable = true;
  };
  imports = [
    ./waybar.nix
  ];
}
