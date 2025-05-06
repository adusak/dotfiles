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
  };

  outputs =
    inputs@{
      self,
      nix-darwin,
      nixpkgs,
      home-manager,
      nix-homebrew,
      catppuccin,
      ...
    }:
    let
      configuration =
        { pkgs, ... }:
        {
          nixpkgs.config.allowUnfree = true;
          # Necessary for using flakes on this system.
          nix.settings.experimental-features = "nix-command flakes";
          # This is an example of an overelay that allows chaning the binary that gets installed
          nixpkgs.overlays = [
            (final: prev: {
                aerospace = prev.aerospace.overrideAttrs (oldAttrs: rec {
                  version = "0.18.5-Beta";
                  src = prev.fetchzip {
                    url = "https://github.com/nikitabobko/AeroSpace/releases/download/v${version}/AeroSpace-v${version}.zip";
                    sha256 = "sha256-rF4emnLNVE1fFlxExliN7clSBocBrPwQOwBqRtX9Q4o";
                  };
                });
            })
          ];

          environment.systemPackages = with pkgs; [
            fish
            neofetch
            vim
            tmux
            nixfmt-rfc-style
            wishlist # ssh sessions manager
            aria2
            xcbeautify
            maccy
            neovim
            ripgrep
            aerospace
            jankyborders
            sketchybar
            sketchybar-app-font
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
            ];
            casks = [
              "font-sf-pro"
              "steam"
              "dbeaver-community"
              "element"
              "marta"
              "boop"
              "jetbrains-toolbox"
              "microsoft-teams"
              "raycast"
              "anytype"
              "cyberduck"
              "db-browser-for-sqlite"
              "omnidisksweeper"
              "textmate"
              "wireshark"
              "ghostty"
              "visual-studio-code"
              "numi"
              "macfuse"
              "latest"
              "klogg"
              "netnewswire"
              "numi"
              "orbstack"
              "powershell"
              "qbittorrent"
              "qlmarkdown"
              "spotify"
              "syntax-highlight"
              "telegram"
              "iina"
              "wezterm"
              "vscodium"
              "xcodes"
              "element"
              "zed"
              "zen-browser"
              ];
          };

          programs.fish.enable = true;
          users.users.melkus = {
            name = "melkus";
            home = "/Users/melkus";
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

          # Set Git commit hash for darwin-version.
          system.configurationRevision = self.rev or self.dirtyRev or null;

          # Used for backwards compatibility, please read the changelog before changing.
          # $ darwin-rebuild changelog
          system.stateVersion = 5;

          # The platform the configuration will be used on.
          nixpkgs.hostPlatform = "aarch64-darwin";
        };
      homeconfig =
        { pkgs, ... }:
        {
          imports = [
            ./modules/home.nix
            # ./modules/darwin
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
    in
    {
      # Build darwin flake using:
      # $ darwin-rebuild build --flake .#simple
      darwinConfigurations.workmac = nix-darwin.lib.darwinSystem {
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
              user = "melkus";
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
            home-manager.users.melkus = homeconfig;
          }
        ];
      };
    };
}
