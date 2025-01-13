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
          services.nix-daemon.enable = true;
          nixpkgs.config.allowUnfree = true;
          # Necessary for using flakes on this system.
          nix.settings.experimental-features = "nix-command flakes";
          # List packages installed in system profile. To search by name, run:
          # $ nix-env -qaP | grep wget
          environment.systemPackages = with pkgs; [
            fish
            vim
            tmux
            nixfmt-rfc-style
            wishlist # ssh sessions manager
            aria2
            xcbeautify
            maccy
            neovim
            ripgrep
            # aerospace
            jankyborders
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
            noto-fonts
            nerd-fonts.noto
            nerd-fonts.space-mono
            mononoki
            nerd-fonts.mononoki
            monaspace
            nerd-fonts.monaspace
            jetbrains-mono
            nerd-fonts.jetbrains-mono
            maple-mono
          ];

          security.pam.enableSudoTouchIdAuth = true;

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
            ./modules/shell.nix
            ./modules/editorconfig.nix
            ./modules/git.nix
            ./modules/mise.nix
            ./modules/terminal/ghostty.nix
            inputs.catppuccin.homeManagerModules.catppuccin
            ./modules/catppuccin.nix
          ];
        };
    in
    {
      # Build darwin flake using:
      # $ darwin-rebuild build --flake .#simple
      darwinConfigurations.workmac = nix-darwin.lib.darwinSystem {
        modules = [
          configuration
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
