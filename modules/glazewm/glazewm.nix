# GlazeWM config for macOS, mirroring the Windows work laptop's config.yaml.
#
# macOS differences from the Windows config:
# - `window_class` is never matched on macOS (a rule entry using it never
#   applies), so rules match on process (app display name) and title only.
# - App names are the macOS ones (NSRunningApplication.localizedName).
# - `shell-exec` doesn't expand env vars / $PATH on macOS, so programs are
#   referenced by absolute path.
# - Borders/corner styles are Windows 11-only; kept for parity, no-op here.
{ pkgs, lib, ... }:
let
  yaml = pkgs.formats.yaml { };

  zebar = "/Applications/Zebar.app/Contents/MacOS/zebar";

  bind = commands: bindings: {
    commands = lib.toList commands;
    bindings = lib.toList bindings;
  };

  # Ordered list of [ name key ]; key drives alt+<key> / alt+shift+<key>.
  workspaces = [
    [
      "1"
      "1"
    ]
    [
      "2"
      "2"
    ]
    [
      "3"
      "3"
    ]
    [
      "4"
      "4"
    ]
    [
      "5"
      "5"
    ]
    [
      "6"
      "6"
    ]
    [
      "7"
      "7"
    ]
    [
      "8"
      "8"
    ]
    [
      "9"
      "9"
    ]
    [
      "Terminal"
      "t"
    ]
    [
      "Communication"
      "c"
    ]
    [
      "Browser"
      "b"
    ]
    [
      "Development"
      "d"
    ]
    [
      "Notes"
      "n"
    ]
    [
      "Files"
      "f"
    ]
    [
      "Agents"
      "a"
    ]
    [
      "Sessions"
      "s"
    ]
  ];
  wsName = ws: builtins.elemAt ws 0;
  wsKey = ws: builtins.elemAt ws 1;

  focusWorkspaceBindings = map (
    ws: bind "focus --workspace ${wsName ws}" "alt+${wsKey ws}"
  ) workspaces;
  moveWorkspaceBindings = map (
    ws:
    bind [
      "move --workspace ${wsName ws}"
      "focus --workspace ${wsName ws}"
    ] "alt+shift+${wsKey ws}"
  ) workspaces;

  # Place new windows once so manual workspace moves remain possible.
  placeOnce = ws: match: {
    commands = [ "move --workspace ${ws}" ];
    on = [ "manage" ];
    run_once = true;
    inherit match;
  };
  process = regex: { window_process.regex = regex; };

  settings = {
    general = {
      startup_commands = [ "shell-exec ${zebar}" ];
      shutdown_commands = [ "shell-exec /usr/bin/pkill -x zebar" ];
      config_reload_commands = [ ];
      focus_follows_cursor = false;
      toggle_workspace_on_refocus = false;
      cursor_jump = {
        enabled = true;
        trigger = "monitor_focus";
      };
      # macOS always uses place_in_corner; set explicitly for clarity.
      hide_method = "place_in_corner";
    };

    gaps = {
      scale_with_dpi = true;
      inner_gap = "5px";
      outer_gap = {
        top = "45px";
        right = "5px";
        bottom = "5px";
        left = "5px";
      };
    };

    window_effects = {
      focused_window = {
        border = {
          enabled = true;
          color = "#8dbcff";
        };
        hide_title_bar.enabled = false;
        corner_style = {
          enabled = false;
          style = "square";
        };
        transparency = {
          enabled = false;
          opacity = "95%";
        };
      };
      other_windows = {
        border = {
          enabled = true;
          color = "#a1a1a1";
        };
        hide_title_bar.enabled = false;
        corner_style = {
          enabled = false;
          style = "square";
        };
        transparency = {
          enabled = false;
          opacity = "0%";
        };
      };
    };

    window_behavior = {
      initial_state = "tiling";
      state_defaults = {
        floating = {
          centered = true;
          shown_on_top = false;
        };
        fullscreen = {
          maximized = false;
          shown_on_top = false;
        };
      };
    };

    workspaces = map (ws: { name = wsName ws; }) workspaces;

    window_rules = [
      {
        commands = [ "ignore" ];
        match = [
          # Ignores any Zebar windows.
          { window_process.equals = "zebar"; }
          # Ignores picture-in-picture windows for browsers.
          { window_title.regex = "[Pp]icture.in.[Pp]icture"; }
          { window_process.equals = "CleanShot X"; }
        ];
      }

      # macOS-only: keep system dialogs floating.
      {
        commands = [ "set-floating" ];
        match = [
          (process "^System Settings$")
          (process "(?i)check ?point|endpoint security")
        ];
      }

      (placeOnce "Terminal" [ (process "(?i)^(ghostty|terminal|iterm2|wezterm)$") ])

      (placeOnce "Communication" [
        (process "(?i)^(microsoft teams.*|microsoft outlook|slack|discord|telegram|element|mail)$")
      ])

      (placeOnce "Browser" [
        {
          window_process.regex = "(?i)^(firefox|zen|safari|google chrome|microsoft edge|brave browser)$";
          window_title.not_regex = "(?i)picture.in.picture";
        }
      ])

      (placeOnce "Development" [
        (process "(?i)^(code|code - insiders|vscodium|zed|xcode|rider|intellij idea.*|pycharm.*|webstorm|phpstorm|clion|goland|datagrip|rubymine|rustrover)$")
      ])

      (placeOnce "Notes" [
        (process "(?i)^(microsoft onenote|obsidian|notes|textedit|anytype)$")
      ])

      (placeOnce "Files" [ (process "(?i)^(finder|marta)$") ])

      (placeOnce "Agents" [ (process "(?i)^(github.*|claude|cursor|windsurf)$") ])
    ];

    binding_modes = [
      # When enabled, the focused window can be resized via arrow keys or HJKL.
      {
        name = "resize";
        keybindings = [
          (bind "resize --width -2%" [
            "h"
            "left"
          ])
          (bind "resize --width +2%" [
            "l"
            "right"
          ])
          (bind "resize --height +2%" [
            "k"
            "up"
          ])
          (bind "resize --height -2%" [
            "j"
            "down"
          ])
          (bind "wm-disable-binding-mode --name resize" [
            "escape"
            "enter"
            "alt+r"
          ])
        ];
      }
    ];

    keybindings = [
      (bind "focus --direction left" [
        "alt+h"
        "alt+left"
      ])
      (bind "focus --direction right" [
        "alt+l"
        "alt+right"
      ])
      (bind "focus --direction up" [
        "alt+k"
        "alt+up"
      ])
      (bind "focus --direction down" [
        "alt+j"
        "alt+down"
      ])

      (bind "move --direction left" [
        "alt+shift+h"
        "alt+shift+left"
      ])
      (bind "move --direction right" [
        "alt+shift+l"
        "alt+shift+right"
      ])
      (bind "move --direction up" [
        "alt+shift+k"
        "alt+shift+up"
      ])
      (bind "move --direction down" [
        "alt+shift+j"
        "alt+shift+down"
      ])

      (bind "resize --width -2%" "alt+u")
      (bind "resize --width +2%" "alt+p")
      (bind "resize --height +2%" "alt+o")
      (bind "resize --height -2%" "alt+i")

      (bind "wm-enable-binding-mode --name resize" "alt+r")
      (bind "wm-toggle-pause" "alt+shift+p")
      (bind "toggle-tiling-direction" "alt+v")
      (bind "wm-cycle-focus" "alt+space")
      (bind "toggle-floating --centered" "alt+shift+space")
      (bind "toggle-tiling" "alt+ctrl+space")
      (bind "toggle-fullscreen" "lctrl+alt+f")
      (bind "toggle-minimized" "alt+m")
      (bind "close" "alt+shift+q")
      (bind "wm-exit" "alt+shift+e")
      (bind "wm-reload-config" "alt+shift+r")
      (bind "wm-redraw" "alt+shift+w")

      # Windows config launches cmd; open Ghostty instead.
      (bind "shell-exec /usr/bin/open -na Ghostty" "alt+enter")

      (bind "focus --next-active-workspace" "alt+page_down")
      (bind "focus --prev-active-workspace" "alt+page_up")
      (bind "focus --recent-workspace" "alt+backspace")
    ]
    ++ focusWorkspaceBindings
    ++ [
      (bind "move-workspace --direction left" "lctrl+alt+shift+a")
      (bind "move-workspace --direction right" "lctrl+alt+shift+d")
      (bind "move-workspace --direction up" "lctrl+alt+shift+w")
      (bind "move-workspace --direction down" "lctrl+alt+shift+s")
    ]
    ++ moveWorkspaceBindings;
  };
in
{
  home.file.".glzr/glazewm/config.yaml".source = yaml.generate "glazewm-config.yaml" settings;

  # Start GlazeWM at login (installed to /Applications by the Homebrew cask).
  launchd.agents.glazewm = {
    enable = true;
    config = {
      ProgramArguments = [
        "/Applications/GlazeWM.app/Contents/MacOS/glazewm"
        "start"
      ];
      RunAtLoad = true;
      ProcessType = "Interactive";
    };
  };
}
