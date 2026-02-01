{ pkgs, config, lib, inputs, ... }: {
  config = {
    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      extraSpecialArgs = {
        inherit inputs;
      };
    };

    hardware.graphics.enable = true;
  };

  imports = with inputs; [
    nur.modules.nixos.default
    agenix.nixosModules.default
    # ../age.nix
    ../configuration.nix
    home-manager.nixosModules.home-manager
    ../fonts.nix
    ../software-config/dm.nix
    ../software-config/firefox.nix
    ../software-config/osd.nix
    ../software-config/virtualisation.nix
  ];
}
