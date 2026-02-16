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
  };
  
  imports = [
    ../age.nix

    ./common.nix
    ./hardware-configuration.nix
  ];
}
