{ lib, config, ... }:
let
  cfg = config.user.bluetooth;
in
{
  options.user.bluetooth = with lib; {
    enable = mkEnableOption "Bluetooth";
  };

  config = lib.mkIf cfg.enable {
    services.mpris-proxy.enable = true;
  };
}
