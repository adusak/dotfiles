{ pkgs, ... }:
{
  programs.mise = {
    enable = true;
    enableFishIntegration = true;
  };
}
