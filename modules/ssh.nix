{
  lib,
  config,
  secrets,
  ...
}: let
  cfg = config.user.ssh;
in {
  options.user.ssh = with lib; {
    enable = mkEnableOption "SSH";
    hosts = {
      github = mkEnableOption "GitHub host configuration";
    };
  };
  config = lib.mkIf cfg.enable {
    programs.ssh = {
      enable = true;
      matchBlocks = {
        "github.com" = {
          host = "github.com";
          identityFile = secrets.github-ssh.path;
        };
      };
    };
  };
}
