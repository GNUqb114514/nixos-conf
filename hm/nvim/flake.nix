{
  description = "My simple system configuration - Neovim configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";

    systems.url = "github:nix-systems/default";

    flake-parts.url = "github:hercules-ci/flake-parts";

    nvf = {
      url = "github:notashelf/nvf";
      # You can override the input nixpkgs to follow your system's
      # instance of nixpkgs. This is safe to do as nvf does not depend
      # on a binary cache.
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
      inputs.systems.follows = "systems";
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

  outputs =
    {
      nixpkgs,
      systems,
      flake-parts,
      nvf,
      nerdicons-nvim,
      vim-barbaric,
      ...
    }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } (
      {
        config,
        ...
      }@top:
      {
        imports = [ ];
        systems = import systems;
        flake = {
          homeModules.default =
            {
              config,
              lib,
              pkgs,
              ...
            }:
            {
              options.user.nvim = with lib; {
                inputs = mkOption {
                  description = "Inputs of my emacs configuration flake.";
                  internal = true;
                  readOnly = true;
                };

                enable = mkEnableOption "neovim";
                exrc = mkEnableOption "exrc";
                neogit = mkEnableOption "neogit";
                fold = mkEnableOption "fold enhancement";
              };

              imports = [
                inputs.nvf.homeManagerModules.default
                
                ./graphical.nix
                ./utility.nix
                ./programming.nix
                ./completion.nix
                ./programming
              ];
            
              config = let cfg = config.user.nvim; in lib.mkIf cfg.enable {
                user.nvim.inputs = inputs;
                # Add clipboard provider
                home.packages = with pkgs; [ wl-clipboard ];
            
                programs.neovim.enable = true;
                programs.neovim.defaultEditor = true;
            
                programs.nvf.enable = true;
            
                programs.nvf.settings.vim = lib.mkMerge [
                  {
                    globals.mapleader = " ";
            
                    lineNumberMode = "relNumber";
                    searchCase = "smart";
                    options = {
                      cursorlineopt = "both";
                      cursorline = true;
                      inherit (cfg) exrc;
                      wrap = false;
                      showmode = false;
                    };
            
                    # Automatic shiftwidth changing
                    utility.sleuth.enable = true;
            
                    keymaps = [
                      {
                        key = "<leader>nh";
                        mode = "n";
                        action = "<cmd>nohlsearch<CR>";
                      }
                    ];
            
                    autopairs.nvim-autopairs.enable = true;
            
                    mini.ai.enable = true;
                  }
                  (lib.mkIf config.user.rime.enable {
                    extraPlugins = {
                      "vimplugin-vim-barbaric" = {
                        package = pkgs.vimUtils.buildVimPlugin {
                          name = "vim-barbaric";
                          src = inputs.vim-barbaric;
                        };
                      };
                    };
                  })
                  (lib.mkIf cfg.neogit {
                    lazy.plugins = {
                      "neogit" = {
                        package = pkgs.vimPlugins.neogit;
                        cmd = [ "Neogit" ];
                      };
                      "diffview.nvim" = {
                        package = pkgs.vimPlugins.diffview-nvim;
                        setupOpts.keymaps.file_panel = [
                          [
                            "n"
                            "q"
                            "<cmd>tabclose<CR>"
                          ]
                        ];
                      };
                    };
                  })
                  (lib.mkIf cfg.fold (
                    lib.mkMerge [
                      {
                        options.foldlevelstart = 99;
                        options.foldmethod = "expr";
                        options.foldexpr = "v:lua.vim.treesitter.foldexpr()";
            
                        highlight."Folded" = {
                          fg = config.lib.stylix.colors.withHashtag.orange;
                        };
                      }
                      (lib.mkIf config.user.terminal {
                        luaConfigRC = {
                          foldtext = inputs.nvf.lib.nvim.dag.entryBefore [ "optionsScript" ] (
                            builtins.readFile ./fold_virt_text.lua
                          );
                        };
                        options.fillchars = "fold: ,foldopen:,foldclose:";
            
                        options.foldtext = "v:lua.custom_foldtext()";
                      })
                      (lib.mkIf cfg.lsp.enable {
                        autocmds = [
                          {
                            event = [ "LspAttach" ];
                            # group = "fold";
                            callback = lib.generators.mkLuaInline ''
                              function(event)
                                local client = vim.lsp.get_client_by_id(event.data.client_id)
                                if client and client:supports_method 'text_document/foldingRange' then
                                  local win = vim.api.nvim_get_current_win()
                                  vim.wo[win][0].foldexpr = 'v:lua.vim.lsp.foldexpr()'
                                end
                              end
                            '';
                          }
                        ];
                      })
                    ]
                  ))
                ];
              };
            };
        };
      }
    );
}
