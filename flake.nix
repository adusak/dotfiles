{
  description = "Adik nix-darwin system flake";

  inputs = {
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    catppuccin.url = "github:catppuccin/nix";
    # komorebi-for-mac.url = "git+ssh://git@github.com/KomoCorp/komorebi-for-mac.git";
  };

  outputs =
    inputs@{
      self,
      nix-darwin,
      nixpkgs,
      home-manager,
      nix-homebrew,
      catppuccin,
      # komorebi-for-mac,
      ...
    }:
    let
      # Shared system-level configuration (packages, homebrew, fonts, etc.)
      configuration =
        { pkgs, username, ... }:
        {
          nix.enable = false;
          nixpkgs.config.allowUnfree = true;
          # Necessary for using flakes on this system.
          nix.settings.experimental-features = "nix-command flakes";
          # This is an example of an overelay that allows chaning the binary that gets installed
          nixpkgs.overlays = [
            # komorebi-for-mac.overlays.default
            (final: prev: {
              aerospace = prev.aerospace.overrideAttrs (oldAttrs: rec {
                version = "0.20.3-Beta";
                src = prev.fetchzip {
                  url = "https://github.com/nikitabobko/AeroSpace/releases/download/v${version}/AeroSpace-v${version}.zip";
                  sha256 = "sha256-wrBcslp1W/lOmudMcW+SREL9LZY+wTwidh6Hot5ShGE=";
                };
              });
            })

          ];

          environment.systemPackages = with pkgs; [
            fish
            fastfetch
            vim
            tmux
            nixfmt
            wishlist # ssh sessions manager
            aria2
            xcbeautify
            maccy
            neovim
            powershell
            ripgrep
            aerospace
            jankyborders
            sketchybar
            sketchybar-app-font
            # komorebi-full
            cmake
            clang
            lazyjj
            opencode
            cursor-cli
            # ladybird
          ];

          homebrew = {
            enable = true;
            onActivation = {
              autoUpdate = true;
              upgrade = true;
              cleanup = "zap";
            };

            taps = [
            ];
            brews = [
              "mole"
              "duck"
            ];
            casks = [
              "cursor"
              "anytype"
              "boop"
              "cyberduck"
              "db-browser-for-sqlite"
              "dbeaver-community"
              "element"
              "finetune"
              "font-sf-pro"
              "ghostty"
              "iina"
              "jetbrains-toolbox"
              "klogg"
              "latest"
              "logi-options+"
              "macfuse"
              "marta"
              "microsoft-teams"
              "netnewswire"
              "numi"
              "omnidisksweeper"
              "orbstack"
              "qbittorrent"
              "qlmarkdown"
              "raycast"
              "spotify"
              "steam"
              "syntax-highlight"
              "telegram"
              "textmate"
              "visual-studio-code"
              "vscodium"
              "wezterm"
              "wireshark-app"
              "xcodes-app"
              "zed"
              "zen"
            ];
          };

          programs.fish.enable = true;
          users.users.${username} = {
            name = username;
            home = "/Users/${username}";
            shell = pkgs.fish;
          };

          environment.shells = [
            pkgs.bashInteractive
            pkgs.zsh
            pkgs.fish
          ];

          fonts.packages = with pkgs; [
            intel-one-mono
            fira-code
            nerd-fonts.fira-code
            nerd-fonts.space-mono
            mononoki
            nerd-fonts.mononoki
            monaspace
            jetbrains-mono
            nerd-fonts.jetbrains-mono
            # maple-mono
            # these are ginormous
            # noto-fonts
            # nerd-fonts.noto
            # nerd-fonts.monaspace
          ];

          security.pam.services.sudo_local.touchIdAuth = true;
          system.primaryUser = username;
          # Set Git commit hash for darwin-version.
          system.configurationRevision = self.rev or self.dirtyRev or null;

          # Used for backwards compatibility, please read the changelog before changing.
          # $ darwin-rebuild changelog
          system.stateVersion = 5;

          # The platform the configuration will be used on.
          nixpkgs.hostPlatform = "aarch64-darwin";
        };

      # Shared home-manager module set
      homeconfig =
        { pkgs, ... }:
        {
          imports = [
            ./modules/home.nix
            ./modules/shell.nix
            ./modules/editorconfig.nix
            ./modules/git.nix
            ./modules/mise.nix
            ./modules/terminal/ghostty.nix
            inputs.catppuccin.homeModules.catppuccin
            ./modules/catppuccin.nix
            ./modules/aerospace/aerospace.nix
          ];
        };

      # All known host configurations — used for fish completion
      allHostnames = [
        "workmac"
        "homemac"
      ];

      # Helper: build a darwinSystem for a given hostname + username
      mkDarwinConfig =
        { hostname, username }:
        nix-darwin.lib.darwinSystem {
          specialArgs = { inherit hostname username allHostnames; };
          modules = [
            configuration
            ./darwin.nix
            nix-homebrew.darwinModules.nix-homebrew
            {
              nix-homebrew = {
                # Install Homebrew under the default prefix
                enable = true;
                # Apple Silicon Only: Also install Homebrew under the default Intel prefix for Rosetta 2
                enableRosetta = true;
                # User owning the Homebrew prefix
                user = username;
                # Automatically migrate existing Homebrew installations
                autoMigrate = true;
              };
            }
            home-manager.darwinModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.backupFileExtension = "hmbak";
              home-manager.verbose = true;
              home-manager.extraSpecialArgs = { inherit hostname username allHostnames; };
              home-manager.users.${username} = homeconfig;
            }
          ];
        };
    in
    {
      darwinConfigurations.workmac = mkDarwinConfig {
        hostname = "workmac";
        username = "Adam.Melkus";
      };

      darwinConfigurations.homemac = mkDarwinConfig {
        hostname = "homemac";
        username = "adik";
      };
    };
}
