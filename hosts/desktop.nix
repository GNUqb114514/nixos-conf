{ pkgs, config, lib, ... }: {
  config = {
    networking.hostName = "desktop";

    home-manager.users.qb114514 = import ../users/qb114514.nix;
  };
  
  imports = [
    ./common.nix
  ];
}
