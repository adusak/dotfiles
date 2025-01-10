{ pkgs, config, ... }:
{

  programs.fish.shellInit = ''
        if set -q GHOSTTY_RESOURCES_DIR
          source "$GHOSTTY_RESOURCES_DIR/shell-integration/fish/vendor_conf.d/ghostty-shell-integration.fish"
        end
      '';
  # programs.ghostty = {
  #   # enable = true;
  #   enableFishIntegration = true;
  #   settings = {
  #     theme = "light:catppuccin-latte,dark:catppuccin-mocha";
  #     cursor-click-to-move = true;
  #
  #     window-decoration = true;
  #
  #     window-save-state = "always";
  #     window-padding-balance = true;
  #     # makes it maximizes the window
  #     window-height = 9999;
  #     window-width = 9999;
  #     confirm-close-surface = true;
  #
  #     cursor-style = "block";
  #     cursor-style-blink = true;
  #
  #     clipboard-read = "allow";
  #     clipboard-paste-protection = false;
  #   };
  # };

  xdg.configFile."ghostty/config" = {
    source = config.lib.file.mkOutOfStoreSymlink ./config;
  };
}
