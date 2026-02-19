{
  config,
  pkgs,
  lib,
  ...
}:

{
  # # Home Manager needs a bit of information about you and the paths it should
  # # manage.
  # # Workaround to not being able to have zsh as the default shell via home manager. sucks.
  # programs.bash = {
  #   enable = true;
  #   # This replaces the bash process with zsh for interactive logins
  #   initExtra = ''
  #     if [[ $- == *i* ]]; then
  #       exec zsh
  #     fi
  #   '';
  # };
  home.enableNixpkgsReleaseCheck = false;
  systemd.user.services.waydroid-session = {
    Unit = {
      Description = "Waydroid User Session";
      After = [ "waydroid-container.service" ];
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
    Service = {
      Type = "simple";
      ExecStart = "${pkgs.waydroid-nftables}/bin/waydroid session start";
      ExecStop = "${pkgs.waydroid-nftables}/bin/waydroid session stop";

      # Clean up processes on exit
      KillMode = "mixed";

      # Resource limits: 4GB Max, 3GB cache threshold
      MemoryMax = "4G";
      MemoryHigh = "3G";

      TimeoutStopSec = "15s";
      Restart = "on-failure";
    };
  };

  systemd.user.services.swww = {
    Unit = {
      Description = "Wayland wallpaper daemon";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${pkgs.swww}/bin/swww-daemon";
      ExecStartPost = "${pkgs.swww}/bin/swww img ${config.stylix.image} --transition-type fade";
      Restart = "on-failure";
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };

  stylix = {
    enable = true;
    autoEnable = true;
    image = ./ado.jpeg;
    polarity = "dark";
    opacity.terminal = 0.8;
    icons = {
      enable = true;
      package = pkgs.papirus-icon-theme;

      # You can specify the dark/light variants
      dark = "Papirus-Dark";
      light = "Papirus-Light";
    };
    fonts = {
      monospace = {
        package = pkgs.maple-mono.CN;
        name = "Maple Mono CN";
      };
      emoji = {
        package = pkgs.noto-fonts-color-emoji;
        name = "Noto Color Emoji";
      };
      sizes = {
        applications = 11;
        terminal = 11.5;
        desktop = 12;
        popups = 12;
      };

    };

    targets = {
      nvf.enable = false;
      mako = {
        fonts.override = {
          serif = config.stylix.fonts.monospace;
          sansSerif = config.stylix.fonts.monospace;
          emoji = config.stylix.fonts.monospace;
        };
      };
      firefox = {
        colors.enable = true;
        colorTheme.enable = true;
        profileNames = [ "default" ];
      };
      alacritty = {
        colors.enable = false;
      };
      fuzzel = {
        fonts.override = {
          serif = config.stylix.fonts.monospace;
          sansSerif = config.stylix.fonts.monospace;
          emoji = config.stylix.fonts.monospace;
        };
      };
    };
  };

  services.polkit-gnome.enable = true;

  services.gpg-agent = {
    enable = true;
    defaultCacheTtl = 1800;
    enableSshSupport = true;
    pinentry.package = pkgs.pinentry-curses;
  };

  programs = {
    mpv = {
      enable = true;
    };
    gpg = {
      enable = true;
    };
    git = {
      enable = true;
      signing = {
        key = "10928E38A063FB75";
        signByDefault = true;
      };
      settings = {
        user = {
          name = config.home.username;
          email = "kiokunee@gmail.com";
        };
        safe.directory = "/etc/nixos";
        init = {
          defaultBranch = "main";
        };
        submodule.recurse = true;
        push.recurseSubmodules = "check";
      };
    };
    firefox = {
      enable = true;
      profiles = {
        default = {
          extensions.force = true;
        };
      };
    };

    # TODO: Currently working on my own NVF standalone module.
    # After having that set up, I should switch over to using dev shells for all my projects instead of this mess.
    nvf = {
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

                      home_manager = {
                        expr = ''
                          let
                            flake = builtins.getFlake (toString ./.);
                            options =
                              if flake ? homeConfigurations
                                 && flake.homeConfigurations ? ${config.home.username}
                              then flake.homeConfigurations.${config.home.username}.options
                              else {};
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

    zsh = {
      enable = true;
      initContent = ''
        source $HOME/.zshrc.unix
      '';
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
    };
    starship = {
      enable = true;
    };
    waybar = {
      enable = true;
      systemd.enable = true;
    };
    alacritty = {
      enable = true;
      settings = {
        window = {
          blur = true;
        };
      };
    };
    fuzzel = {
      enable = true;
      settings = {
        main = {
          launch-prefix = "app2unit --";
        };
      };
    };
    bat = {
      enable = true;
    };
    fastfetch = {
      enable = true;
    };
    eza.enable = true;

  };

  home.username = "fish";
  home.homeDirectory = "/home/fish";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.11"; # Please read the comment before changing.

  services = {
    gnome-keyring.enable = true;
    mako = {
      enable = true;
      settings = {
        default-timeout = 8000;
        border-radius = 8;
        border-size = 2;
      };
    };
  };

  home.packages = with pkgs; [
    substratum.hayase
    substratum.wake-home
    app2unit
    seahorse
    ripgrep
    trash-cli
    swww
    wl-clipboard
    vesktop
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/fish/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    NH_HOME_FLAKE = "${config.home.homeDirectory}/.config/home-manager";

    # remove if not using uwsm
    APP2UNIT_SLICES = "a=app-graphical.slice b=background-graphical.slice s=session-graphical.slice";
  };

  # Let Home Manager install and manage itself.
  # programs.home-manager.enable = true;
}
