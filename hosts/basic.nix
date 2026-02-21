{
  pkgs,
  config,
  lib,
  inputs,
  ...
}:
{
  config = {
    hardware.graphics.enable = true;
  };

  imports = with inputs; [
    agenix.nixosModules.default
    disko.nixosModules.disko
  ];
}
