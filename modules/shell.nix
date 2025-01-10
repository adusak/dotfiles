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
}
