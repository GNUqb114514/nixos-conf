{
  disko.devices = {
    disk = {
      main = {
        device = "/dev/sda";
        # No device config in favor of disko-install command-line
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              size = "512M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" ];
              };
            };
            swap = {
              size = "8G";
              content = {
                type = "swap";
                resumeDevice = true;
              };
            };
            root = {
              size = "100%";
              content = {
                type = "btrfs";
                #format = "btrfs";
                subvolumes = {
                  "@root" = {
                    mountpoint = "/";
                    mountOptions = [
                      "compress=zstd:1"
                      "discard=async"
                    ];
                  };
                  "@journal" = {
                    mountpoint = "/var/log";
                    mountOptions = [
                      "compress=zstd:3"
                      "discard=async"
                    ];
                  };
                };
              };
            };
          };
        };
      };
    };
  };
}
