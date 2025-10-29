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

    agenix = {
      url = "github:ryantm/agenix";
      inputs.darwin.follows = "";
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
    nixpkgs,
    nur,
    home-manager,
    agenix,
    ...
  } @ inputs: {
    nixosConfigurations.desktop = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        nur.modules.nixos.default

        ./configuration.nix

        agenix.nixosModules.default

        {
          networking.hostName = "desktop"; # Define your hostname.
        }
        home-manager.nixosModules.home-manager

        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = {inherit inputs;};
          home-manager.users.qb114514 = import ./home.nix;
        }

        ./fonts.nix

        ./software-config/dm.nix

        ./software-config/firefox/systemwide.nix

        ./software-config/de/osd-system.nix

        {
          # Enable OpenGL
          hardware.graphics.enable = true;
        }
      ];
    };
    nixosConfigurations.laptop = nixpkgs.lib.nixosSystem rec {
      system = "x86_64-linux";
      modules = [
        nur.modules.nixos.default

        agenix.nixosModules.default

        ./age.nix

        {
          environment.systemPackages = [agenix.packages.${system}.default];
        }

        ./configuration.nix

        {
          networking.hostName = "laptop"; # Define your hostname.
        }

        home-manager.nixosModules.home-manager

        ({config, ...}: {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = {
            inherit inputs;
            inherit (config.age) secrets;
          };
          home-manager.users.qb114514 = import ./home.nix;
        })

        ./fonts.nix

        ./software-config/dm.nix

        ./software-config/firefox/systemwide.nix

        ./software-config/de/osd-system.nix

        {
          # Enable OpenGL
          hardware.graphics.enable = true;
        }
      ];
    };
  };
}
