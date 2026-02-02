{ pkgs, config, inputs, ...}: let system = "x86_64-linux"; in {
  config = {
    environment.systemPackages = [
      inputs.agenix.packages.${system}.default
    ];

    home-manager = {
      extraSpecialArgs = {
        inherit (config.age) secrets;
      };
      users.qb114514 = import ../users/qb114514.nix;
    };

    networking.hostName = "laptop";

    nixpkgs.overlays = [
      inputs.rust-overlay.overlays.default
    ];

    boot.loader = {
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
      grub = {
        enable = true;
        version = 2;
        device = "nodev";
        efiSupport = true;
      };
    };

    disko.devices = {
      disk = {
        main = {
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
                  mountOptions = ["umask=0077"];
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
                      mountOptions = ["compress=zstd:1" "discard=async"];
                    };
                    "@journal" = {
                      mountpoint = "/var/log";
                      mountOptions = ["compress=zstd:3" "discard=async"];
                    };
                  };
                };
              };
            };
          };
        };
      };
    };
  };
  
  imports = [
    ../age.nix

    ./common.nix

    inputs.disko.nixosModules.disko
  ];
}
