{ pkgs, config, ... }:
{

  xdg.configFile."zellij/config.kdl" = {
    source = config.lib.file.mkOutOfStoreSymlink ./config.kdl;
  };

  programs.zellij = {
    enable = true;
    enableFishIntegration = true;
    settings = {
      theme = "catppuccin-mocha";
      copy_command = "pbcopy";
      copy_on_select = false;
    };
  };


  # xdg.configFile."zellij/themes/catppuccin.kdl" = {
  #   source = config.lib.file.mkOutOfStoreSymlink ./catppuccin.kdl;
  # };
}
