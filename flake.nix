{
  description = "My simple system configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
    };

    systems = {
      url = "github:nix-systems/default";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix = {
      url = "github:ryantm/agenix";
      inputs.darwin.follows = "";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
      inputs.systems.follows = "systems";
    };

    maple-font = {
      url = "github:subframe7536/maple-font";
      flake = false;
    };

    # org-hold = {
    #   url = "github:GNUqb114514/org-hold";
    #   flake = false;
    # };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Subflakes
    hm = {
      url = "./subflakes/hm";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
      inputs.maple-font.follows = "maple-font";
      inputs.systems.follows = "systems";
      inputs.flake-parts.follows = "flake-parts";
    };
  };

  outputs =
    {
      nixpkgs,
      # nur,
      home-manager,
      agenix,
      # fenix,
      flake-parts,
      systems,
      ...
    }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } (
      { ... }:
      {
        imports = [ ];
        flake = {
          nixosConfigurations.desktop = nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            specialArgs = {
              inherit inputs;
            };
            modules = [
              ./hosts/desktop.nix
            ];
          };
          nixosConfigurations.laptop = nixpkgs.lib.nixosSystem rec {
            system = "x86_64-linux";
            specialArgs = {
              inherit inputs;
            };
            modules = [
              ./hosts/laptop.nix
            ];
          };
        };
        systems = import systems;
      }
    );
}
