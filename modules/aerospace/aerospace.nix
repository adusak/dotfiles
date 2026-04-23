{
  pkgs,
  config,
  home,
  ...
}:
{
  programs.aerospace = {
    enable = true;
    launchd.enable = true;
    settings = {
      after-startup-command = [
        "exec-and-forget sketchybar"
      ];

      exec-on-workspace-change = [
        "/bin/bash"
        "-c"
        "sketchybar --trigger aerospace_workspace_change FOCUSED_WORKSPACE=$AEROSPACE_FOCUSED_WORKSPACE"
      ];

      start-at-login = true;

      enable-normalization-flatten-containers = true;
      enable-normalization-opposite-orientation-for-nested-containers = true;

      accordion-padding = 30;
      default-root-container-layout = "tiles";
      default-root-container-orientation = "auto";

      on-focused-monitor-changed = [ "move-mouse monitor-lazy-center" ];
      automatically-unhide-macos-hidden-apps = false;

      on-window-detected = [
        {
          "if".app-id = "com.mitchellh.ghostty";
          run = "move-node-to-workspace T";
        }
        {
          "if".app-id = "org.mozilla.firefox";
          run = "move-node-to-workspace B";
        }
        {
          "if".app-id = "com.jetbrains.rider";
          run = "move-node-to-workspace A";
        }
        {
          "if".app-id = "com.jetbrains.idea";
          run = "move-node-to-workspace A";
        }
        {
          "if".app-id = "com.microsoft.teams2";
          run = "move-node-to-workspace M";
        }
        {
          "if".app-id = "com.apple.systempreferences";
          run = "layout floating";
        }
        {
          "if".app-id = "com.checkpoint.CheckPoint-VPN.app";
          run = "layout floating";
        }
        {
          "if".app-id = "com.anytype.anytype";
          run = "move-node-to-workspace W";
        }
        {
          "if".app-id = "com.apple.mail";
          run = "move-node-to-workspace C";
        }
      ];

      key-mapping.preset = "qwerty";

      gaps = {
        inner.horizontal = 3;
        inner.vertical = 3;
        outer.left = 3;
        outer.bottom = 3;
        outer.right = 3;
        outer.top = [
          { monitor."Built-in Retina" = 3; }
          33
        ];
      };

      mode = {
        main.binding = {
          ctrl-alt-shift-p = "exec-and-forget Users/melkus/tools/scripts/aerospace-clean-ghosts.sh";

          alt-slash = "layout tiles horizontal vertical";
          alt-comma = "layout accordion horizontal vertical";

          alt-h = "focus left";
          alt-j = "focus down";
          alt-k = "focus up";
          alt-l = "focus right";

          alt-shift-h = "move left";
          alt-shift-j = "move down";
          alt-shift-k = "move up";
          alt-shift-l = "move right";

          alt-minus = "resize smart -50";
          alt-equal = "resize smart +50";

          alt-f = "fullscreen";

          ctrl-alt-cmd-shift-1 = "workspace 1";
          alt-1 = "workspace 1";
          alt-2 = "workspace 2";
          alt-3 = "workspace 3";
          alt-4 = "workspace 4";
          alt-5 = "workspace 5";
          alt-6 = "workspace 6";
          alt-7 = "workspace 7";
          alt-a = "workspace DEV-M";
          alt-s = "workspace DEV-S";
          alt-b = "workspace B";
          alt-w = "workspace W";
          alt-m = "workspace M";
          alt-t = "workspace T";
          alt-c = "workspace C";

          alt-shift-1 = [
            "move-node-to-workspace 1"
            "workspace 1"
          ];
          alt-shift-2 = [
            "move-node-to-workspace 2"
            "workspace 2"
          ];
          alt-shift-3 = [
            "move-node-to-workspace 3"
            "workspace 3"
          ];
          alt-shift-4 = [
            "move-node-to-workspace 4"
            "workspace 4"
          ];
          alt-shift-5 = [
            "move-node-to-workspace 5"
            "workspace 5"
          ];
          alt-shift-6 = [
            "move-node-to-workspace 6"
            "workspace 6"
          ];
          alt-shift-7 = [
            "move-node-to-workspace 7"
            "workspace 7"
          ];
          alt-shift-b = [
            "move-node-to-workspace B"
            "workspace B"
          ];
          alt-shift-w = [
            "move-node-to-workspace W"
            "workspace W"
          ];
          alt-shift-m = [
            "move-node-to-workspace M"
            "workspace M"
          ];
          alt-shift-t = [
            "move-node-to-workspace T"
            "workspace T"
          ];
          alt-shift-c = [
            "move-node-to-workspace C"
            "workspace C"
          ];
          alt-shift-a = [
            "move-node-to-workspace DEV-M"
            "workspace DEV-M"
          ];
          alt-shift-s = [
            "move-node-to-workspace DEV-S"
            "workspace DEV-S"
          ];

          alt-tab = "workspace-back-and-forth";
          alt-shift-tab = "move-workspace-to-monitor --wrap-around next";
          alt-shift-cmd-tab = "move-node-to-monitor --wrap-around next";

          alt-shift-semicolon = "mode service";
        };

        service.binding = {
          esc = [
            "reload-config"
            "mode main"
          ];
          r = [
            "flatten-workspace-tree"
            "mode main"
          ];
          f = [
            "layout floating tiling"
            "mode main"
          ];
          backspace = [
            "close-all-windows-but-current"
            "mode main"
          ];

          alt-shift-h = [
            "join-with left"
            "mode main"
          ];
          alt-shift-j = [
            "join-with down"
            "mode main"
          ];
          alt-shift-k = [
            "join-with up"
            "mode main"
          ];
          alt-shift-l = [
            "join-with right"
            "mode main"
          ];

          down = "volume down";
          up = "volume up";
          shift-down = [
            "volume set 0"
            "mode main"
          ];
        };
      };

      exec = {
        inherit-env-vars = true;
        env-vars.PATH = "/run/current-system/sw/bin/:\${PATH}";
      };
    };
  };
}
