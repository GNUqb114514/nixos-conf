{
  description = "My NixOS config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    founder-overlay.url = "github:brsvh/chinese-fonts-overlay/main";

    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {self, nixpkgs, nur, home-manager, nixvim, ...}@inputs: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        nur.modules.nixos.default

        nixvim.nixosModules.nixvim

        ({ pkgs, ...}: {
          nixpkgs.overlays = [
          inputs.founder-overlay.overlays.default
          ];
        })

        ./configuration.nix

        home-manager.nixosModules.home-manager {
          home-manager.backupFileExtension = "backup";
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = { inherit inputs; };
          home-manager.users.qb114514 = import ./home.nix;
        }

        ./fonts.nix

        ./im.nix

        ./software-config/firefox-systemwide.nix

        ./software-config/nvim.nix
      ];
    };
  };
}
