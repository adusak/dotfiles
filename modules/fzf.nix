{ ... }:
{
  programs.fzf = {
    enable = true;
    enableFishIntegration = true;
    # Atuin owns Ctrl-R; keep fzf's Ctrl-T / Alt-C widgets only.
    historyWidget.command = "";
  };
}
