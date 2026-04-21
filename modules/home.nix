{ pkgs, username, ... }:
{
  home.username = username;
  home.stateVersion = "23.11";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  programs.nix-index.enable = true;

  home.packages = with pkgs; [
    # (
    #   with dotnetCorePackages;
    #   combinePackages [
    #     sdk_8_0
    #     sdk_9_0
    #   ]
    # )
  ];

  services.skhd = {
    enable = false;
    config = ''
      # Focus windows
      alt - h                 : komorebic focus left
      alt - j                 : komorebic focus down
      alt - k                 : komorebic focus up
      alt - l                 : komorebic focus right
      alt + shift - 0x21      : komorebic cycle-focus previous # 0x21 is [
      alt + shift - 0x1E      : komorebic cycle-focus next # 0x1E is ]

      # Move windows
      alt + shift - h         : komorebic move left
      alt + shift - j         : komorebic move down
      alt + shift - k         : komorebic move up
      alt + shift - l         : komorebic move right
      alt + shift - return    : komorebic promote

      # Stack windows
      ctrl + alt - left       : komorebic stack left
      ctrl + alt - down       : komorebic stack down
      ctrl + alt - up         : komorebic stack up
      ctrl + alt - right      : komorebic stack right
      alt - 0x29              : komorebic unstack # 0x29 is ;
      alt - 0x21              : komorebic cycle-stack previous # 0x21 is [
      alt - 0x1E              : komorebic cycle-stack next # 0x1E is ]

      # Workspace layer
      alt + shift - 0x29      : komorebic toggle-workspace-layer # 0x29 is ;

      # Resize
      alt - 0x18              : komorebic resize-axis horizontal increase # 0x18 is +
      alt - 0x1B              : komorebic resize-axis horizontal decrease # 0x1B is -
      alt + shift - 0x18      : komorebic resize-axis vertical increase
      alt + shift - 0x1B      : komorebic resize-axis vertical decrease

      # Manipulate windows
      alt - t                 : komorebic toggle-float
      alt + shift - t         : komorebic toggle-workspace-float-override
      alt + shift - f         : komorebic toggle-monocle

      # Window manager options
      alt + shift - r         : komorebic retile
      alt - p                 : komorebic toggle-pause
      alt - 0                 : komorebic toggle-window-container-behaviour
      alt - 0x2B              : komorebic toggle-lock

      # Layouts
      alt - x                 : komorebic flip-layout horizontal
      alt - y                 : komorebic flip-layout vertical
      alt + shift - x         : komorebic session-float-rule

      # Workspaces
      alt - 1                 : komorebic focus-workspace 0
      alt - 2                 : komorebic focus-workspace 1
      alt - 3                 : komorebic focus-workspace 2
      alt - 4                 : komorebic focus-workspace 3

      # Move windows across workspaces
      alt + shift - 1         : komorebic move-to-workspace 0
      alt + shift - 2         : komorebic move-to-workspace 1
      alt + shift - 3         : komorebic move-to-workspace 2
      alt + shift - 4         : komorebic move-to-workspace 3
    '';
  };

  home.sessionVariables = {
    EDITOR = "code";
  };

  home.sessionVariables = {
    LC_ALL = "en_US.UTF-8";
    LC_CTYPE = "en_US.UTF-8";
    WORKSPACE = "$HOME/workspace";
    WORKDIR = "$WORKSPACE/ysoft";
    DOTNET_ROOT = "$HOME/.dotnet";
  };

  # ensures ~/Developer folder exists.
  # this folder is later assumed by other activations, specially on darwin.
  home.activation.workspace = ''
    mkdir -p ~/workspace
  '';
}
