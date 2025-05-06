{ pkgs, config, home, ... }:
{
 # home.file.".foo".source = config.lib.file.mkOutOfStoreSymlink ./some-source-file;
  # config.lib.file.mkOutOfStoreSymlink ../config/nvim
  programs.aerospace = {
    enable = false;
    # settings =
  };
}
