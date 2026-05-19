{
  pkgs,
  username,
  hostname,
  ...
}:
{
  wsl = {
    enable = true;
    defaultUser = username;
    startMenuLaunchers = true;
    # Forward systemd into WSL2 so user services (atuin, etc.) work.
    nativeSystemd = true;
  };

  networking.hostName = hostname;

  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  environment.systemPackages = with pkgs; [
    fish
    fastfetch
    vim
    tmux
    nixfmt-rfc-style
    wishlist
    aria2
    neovim
    powershell
    ripgrep
    cmake
    clang
    lazyjj
    opencode
    cursor-cli
    # Tools that are useful inside WSL specifically.
    wslu
    git
  ];

  programs.fish.enable = true;

  users.users.${username} = {
    isNormalUser = true;
    home = "/home/${username}";
    shell = pkgs.fish;
    extraGroups = [
      "wheel"
      "docker"
    ];
  };

  environment.shells = [
    pkgs.bashInteractive
    pkgs.zsh
    pkgs.fish
  ];

  fonts.packages = with pkgs; [
    intel-one-mono
    fira-code
    nerd-fonts.fira-code
    nerd-fonts.space-mono
    mononoki
    nerd-fonts.mononoki
    monaspace
    jetbrains-mono
    nerd-fonts.jetbrains-mono
  ];

  # https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion
  system.stateVersion = "25.11";
}
