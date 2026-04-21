{ pkgs, ... }:
{
  imports = [
    ./fish
    ./starship.nix
    ./bat.nix
    ./fzf.nix
    ./zellij/zellij.nix
  ];

  programs.zoxide.enable = true;

  programs.eza = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.atuin = {
    enable = true;
    enableFishIntegration = true;
    settings = {
      auto_sync = true;
      sync_frequency = "5m";
      sync_address = "https://atuin.melk.us";
      search_mode = "fuzzy";
    };
  };

  # programs.yazi = {
  #   enable = true;
  #   enableFishIntegration = true;
  # };
}
