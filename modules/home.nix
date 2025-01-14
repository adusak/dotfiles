{ pkgs, ... }:
{
  home.username = "melkus";
  home.stateVersion = "23.11";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  programs.nix-index.enable = true;

  home.packages = with pkgs; [
    (
      with dotnetCorePackages;
      combinePackages [
        sdk_8_0
        sdk_9_0
      ]
    )
  ];

  home.sessionVariables = {
    EDITOR = "code";
  };

  home.sessionVariables = {
    LC_ALL = "en_US.UTF-8";
    LC_CTYPE = "en_US.UTF-8";
    WORKSPACE = "$HOME/workspace";
    WORKDIR = "$WORKSPACE/ysoft";
  };

  # ensures ~/Developer folder exists.
  # this folder is later assumed by other activations, specially on darwin.
  home.activation.workspace = ''
    mkdir -p ~/workspace
  '';
}
