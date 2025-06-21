{
  description = "My simple system configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";

    niri-flake = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix.url = "github:danth/stylix";

    nvf = {
      url = "github:notashelf/nvf";
      # You can override the input nixpkgs to follow your system's
      # instance of nixpkgs. This is safe to do as nvf does not depend
      # on a binary cache.
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nerdicons-nvim = {
      url = "github:nvimdev/nerdicons.nvim";
      flake = false;
    };

    vim-barbaric = {
      url = "github:rlue/vim-barbaric";
      flake = false;
    };
  };

  outputs = {
    self,
    nixpkgs,
    nur,
    nvf,
    home-manager,
    stylix,
    niri-flake,
    nerdicons-nvim,
    vim-barbaric,
    ...
  } @ inputs: {
    nixosConfigurations.desktop = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        nur.modules.nixos.default

        ./configuration.nix

        home-manager.nixosModules.home-manager

        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = {inherit inputs;};
          home-manager.users.qb114514 = import ./home.nix;
        }

        ./fonts.nix

        ./software-config/im.nix

        ./software-config/dm.nix

        ./software-config/firefox/systemwide.nix
      ];
    };
  };
}
