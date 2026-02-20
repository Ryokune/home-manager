{
  self,
  config,
  pkgs,
  lib,
  ...
}:
{
  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };
  programs.nvf = {

    enable = true;

    # Your settings need to go into the settings attribute set
    # most settings are documented in the appendix

    settings = {
      vim = {
        comments = {
          comment-nvim.enable = true;
        };
        autopairs = {
          nvim-autopairs.enable = true;
        };
        viAlias = false;
        vimAlias = true;
        undoFile.enable = true;
        preventJunkFiles = true;
        tabline.nvimBufferline.enable = true;

        keymaps = [
          {
            key = "<leader>e";
            mode = "n";
            silent = true;
            action = ":Neotree toggle reveal<CR>";
          }
          {
            key = "<leader>[";
            mode = "n";
            silent = true;
            action = "vim.fn.search('[([{<]', 'n')";
          }
          {
            key = "<leader>]";
            mode = "n";
            silent = true;
            action = "vim.fn.search('[([{<]', 'bn')";
          }
        ];

        options = {
          clipboard = "unnamedplus";
          ignorecase = true;
          mouse = "a";
          autoindent = true;
          smartindent = true;
          tabstop = 2;
          shiftwidth = 2;
          softtabstop = 2;
          expandtab = true;
          updatetime = 50;
        };

        extraPlugins = {
          log-highlight = {
            package = pkgs.vimUtils.buildVimPlugin {
              name = "log-highlight-nvim";
              src = pkgs.fetchFromGitHub {
                owner = "fei6409";
                repo = "log-highlight.nvim";
                rev = "ca88628f6dd3b9bb46f9a7401669e24cf7de47a4";
                sha256 = "sha256-s2GL6ddIA9wJI+K/irDtW7xvM/ms8it+04akr3ljJLA=";
              };
            };
          };
        };

        statusline.lualine.enable = true;
        telescope.enable = true;
        autocomplete.blink-cmp.enable = true;
        treesitter.enable = true;
        visuals.fidget-nvim.enable = true;
        binds.whichKey.enable = true;
        filetree.neo-tree.enable = true;

        diagnostics = {
          enable = true;
          config = {
            update_in_insert = true;
            signs.text = lib.generators.mkLuaInline ''
              {
                [vim.diagnostic.severity.ERROR] = "󰅚 ",
                [vim.diagnostic.severity.WARN] = "󰀪 ",
              }
            '';
            virtual_text = {
              format = lib.generators.mkLuaInline ''
                function(diagnostic)
                  return string.format("%s (%s)", diagnostic.message, diagnostic.source)
                end
              '';
            };
          };
        };

        lsp = {

          trouble.enable = true;
          formatOnSave = true;
          enable = true;
          lspconfig.enable = true;
          servers = {
            nixd = {
              settings = {
                nixd = {
                  nixpkgs = {
                    expr = "import <nixpkgs> { }";
                  };
                  options = {
                    flake_parts = {
                      expr = ''
                        let
                            flake = builtins.getFlake (toString ./.);

                            debugOptions = 
                              if flake ? debug && flake.debug ? options
                              then flake.debug.options
                              else {};

                            systemOptions = 
                              if flake ? currentSystem && flake.currentSystem ? options
                              then flake.currentSystem.options
                              else {};
                          in
                            debugOptions // systemOptions
                      '';
                    };
                    # TODO: Learn to use dev shells because. Holy. Shit.
                    home_manager = {
                      expr = ''
                        let
                          flake = builtins.getFlake (toString ./.); 
                          options =
                            if flake ? homeConfigurations
                               && flake.homeConfigurations ? ${config.home.username}
                            then flake.homeConfigurations.${config.home.username}.options
                            else 
                            if flake ? legacyPackages
                               && flake.legacyPackages ? ${pkgs.stdenv.hostPlatform.system} 
                               && flake.legacyPackages.${pkgs.stdenv.hostPlatform.system} ? homeConfigurations 
                               && flake.legacyPackages.${pkgs.stdenv.hostPlatform.system}.homeConfigurations ? ${config.home.username} 
                            then flake.legacyPackages.${pkgs.stdenv.hostPlatform.system}.homeConfigurations.${config.home.username}.options
                            else
                            if flake ? legacyPackages
                               && flake.legacyPackages ? ${pkgs.stdenv.hostPlatform.system} 
                               && flake.legacyPackages.${pkgs.stdenv.hostPlatform.system} ? homeConfigurations 
                               && flake.legacyPackages.${pkgs.stdenv.hostPlatform.system}.homeConfigurations ? "${config.home.username}@siesta"
                            then flake.legacyPackages.${pkgs.stdenv.hostPlatform.system}.homeConfigurations."${config.home.username}@siesta".options 
                            else
                            {};
                        in
                          options
                      '';
                    };
                    nixos = {
                      expr = ''
                        let
                          flake = builtins.getFlake (toString ./.);
                          options =
                            if flake ? nixosConfigurations
                               && flake.nixosConfigurations ? siesta
                            then flake.nixosConfigurations.siesta.options
                            else {};
                        in
                          options
                      '';
                    };
                  };
                };
              };
            };
          };

        };
        languages = {
          enableTreesitter = true;
          nix = {
            enable = true;
            lsp.servers = [ "nixd" ];
          };
        };
      };
    };

  };
}
