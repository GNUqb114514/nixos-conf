{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:
let
  system = "x86_64-linux";
in
{
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

    boot.loader = {
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
      grub = {
        enable = true;
        device = "nodev";
        efiSupport = true;
      };
    };

    # Hardware config
    boot.initrd.availableKernelModules = [
      "xhci_pci"
      "ahci"
      "usb_storage"
      "sd_mod"
      "rtsx_usb_sdmmc"
      "r8169"
    ];
    boot.initrd.kernelModules = [ "r8169" ];
    boot.kernelModules = [
      "kvm-intel"
      "r8169"
    ];
    boot.extraModulePackages = [ ];
    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
    hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

    hardware.enableRedistributableFirmware = true;
    boot.kernelPackages = pkgs.linuxPackages_latest;

    services.watt.enable = true;

    services.logind.settings.Login = {
      HandleLidSwitch = "ignore";
      HandleLidSwitchExternalPower = "lock";
      IdleAction = "lock";
    };

    users.groups.input.members = [ "qb114514" ];
    users.groups.video.members = [ "qb114514" ];

    hardware.bluetooth.enable = true;
    services.blueman.enable = true;

    zramSwap.enable = true;
    zramSwap.memoryPercent = 30;
    # zramSwap.memoryPercent = 300; # Only for building huge things
  };

  imports = [
    ../age.nix

    ./common.nix
    ./laptop-disko.nix

    inputs.disko.nixosModules.disko
    inputs.watt.nixosModules.watt
  ];
}
