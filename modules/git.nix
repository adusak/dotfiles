{ pkgs, ... }:
{
  home.packages = [
    pkgs.git-lfs
  ];
  programs.delta = {
    enable = true;
    enableGitIntegration = true;
  };
  programs.jujutsu = {
    enable = true;
  }
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Adam Melkus";
        email = "adam@melkus.cc";
      };
      alias = {
        co = "checkout";
        count = "shortlog -sn";
        g = "grep --break --heading --line-number";
        gi = "grep --break --heading --line-number -i";
        changed = ''show --pretty="format:" --name-only'';
        fm = "fetch-merge";
        please = "push --force-with-lease";
        commit = "commit -s";
        commend = "commit -s --amend --no-edit";
        lt = "log --tags --decorate --simplify-by-decoration --oneline";
        unshallow = "fetch --prune --tags --unshallow";
      };
      lfs = {
        enable = true;
      };
      core = {
        editor = "nvim";
        compression = -1;
        autocrlf = "input";
        whitespace = "trailing-space,space-before-tab";
        precomposeunicode = true;
      };
      color = {
        diff = "auto";
        status = "auto";
        branch = "auto";
        ui = true;
      };
      advice = {
        addEmptyPathspec = false;
      };
      apply = {
        whitespace = "nowarn";
      };
      help = {
        autocorrect = 1;
      };
      grep = {
        extendRegexp = true;
        lineNumber = true;
      };
      push = {
        autoSetupRemote = true;
        default = "simple";
      };
      submodule = {
        fetchJobs = 4;
      };
      log = {
        showSignature = false;
      };
      rerere = {
        enabled = true;
      };
      pull = {
        ff = "only";
      };
      init = {
        defaultBranch = "main";
      };
    };
    includes = [
      {
        contents = {
          user = {
            email = "adam.melkus@ysoft.com";
            signingkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILr1iDBFfnSP5QbSwW6ahPkhcxFeqtg6OTJmLW80M/wE";
          };
          gpg.format = "ssh";
          gpg.ssh.program = "/Applications/1Password.app/Contents/MacOS/op-ssh-sign";
          commit.gpgSign = true;
        };
        condition = "gitdir:~/workspace/ysoft/";
      }
    ];
  };
}
