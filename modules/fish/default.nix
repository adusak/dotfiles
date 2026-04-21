{
  pkgs,
  hostname,
  allHostnames,
  ...
}:
let
  hostnameArgs = builtins.concatStringsSep " " allHostnames;
in
{
  programs.fish = {
    enable = true;
    shellInit = ''
      if test -f ~/.localrc.fish
          source ~/.localrc.fish
      end
    '';
    interactiveShellInit = ''
      # disable fish greeting
      set fish_greeting
      fish_config theme choose catppuccin
      fish_add_path -p $DOTNET_ROOT $DOTNET_ROOT/tools
      fish_add_path -p ~/.bin
      fish_add_path -p ~/.local/bin
      fish_add_path -p ~/.nix-profile/bin /nix/var/nix/profiles/default/bin /run/current-system/sw/bin
      set -a fish_complete_path ~/.nix-profile/share/fish/completions/ ~/.nix-profile/share/fish/vendor_completions.d/

      # use fish inside nix-shell
      ${pkgs.any-nix-shell}/bin/any-nix-shell fish --info-right | source

      # nixreload completion: suggest available flake hostnames
      complete -c nixreload -f -a "${hostnameArgs}" -d "nix-darwin configuration"
    '';
    plugins = [
      {
        name = "autopair";
        src = pkgs.fishPlugins.autopair-fish.src;
      }
    ];
    functions = {
      nixreload = {
        description = "Rebuild nix-darwin configuration";
        argumentNames = [ "target" ];
        body = ''
          if test -z "$target"
              set target ${hostname}
          end
          sudo darwin-rebuild switch --flake ~/.config/nix-darwin#$target
        '';
      };
      "grc.wrap" = {
        argumentNames = [ "executable" ];
        body = ''
          set executable $argv[1]

          if test (count $argv) -gt 1
            set arguments $argv[2..(count $argv)]
          else
            set arguments
          end

          set optionsvariable "grcplugin_"$executable
          set options $$optionsvariable

          command grc -es --colour=auto $executable $options $arguments
        '';
      };
      replay = {
        description = "Run Bash commands replaying changes in Fish";
        body = ''
          switch "$argv"
              case -v --version
                  echo "replay, version 1.2.1"
              case "" -h --help
                  echo "Usage: replay <commands>  Run Bash commands replaying changes in Fish"
                  echo "Options:"
                  echo "       -v or --version  Print version"
                  echo "       -h or --help     Print this help message"
              case \*
                  set --local env
                  set --local sep @$fish_pid(random)(command date +%s)
                  set --local argv $argv[1] (string escape -- $argv[2..-1])
                  set --local out (command bash -c "
                      $argv
                      status=\$?
                      [ \$status -gt 0 ] && exit \$status

                      command compgen -e | command awk -v sep=$sep '{
                          gsub(/\n/, \"\\\n\", ENVIRON[\$0])
                          print \$0 sep ENVIRON[\$0]
                      }' && alias
                  ") || return

                  string replace --all -- \\n \n (
                      for line in $out
                          if string split -- $sep $line | read --local --line name value
                              set --append env $name

                              contains -- $name SHLVL PS1 BASH_FUNC || test "$$name" = "$value" && continue

                              if test "$name" = PATH
                                  echo set PATH (string split -- : $value | string replace --regex --all -- '(^.*$)' '"$1"')
                              else if test "$name" = PWD
                                  echo builtin cd "\"$value\""
                              else
                                  echo "set --global --export $name "(string escape -- $value)
                              end
                          else
                              set --query env[1] && string match --entire --regex -- "^alias" $line || echo "echo \"$line\""
                          end
                      end | string replace --all -- \$ \\\$
                      for name in (set --export --names)
                          contains -- $name $env || echo "set --erase $name"
                      end
                  ) | source
          end
        '';
      };
    };
    shellAliases = {
      # docker
      d = "docker";
      dp = "podman";

      cat = "bat";

      # git
      g = "git";
      gl = "git pull --prune";
      glg = "git log --graph --decorate --oneline --abbrev-commit";
      glga = "glg --all";
      gp = "git push origin HEAD";
      gpa = "git push origin --all";
      gd = "git diff";
      gc = "git commit";
      gca = "git commit -a";
      gco = "git checkout";
      gb = "git branch -v";
      ga = "git add";
      gaa = "git add -A";
      gcm = "git commit -sm";
      gcam = "git commit -sam";
      gs = "git status -sb";
      glnext = "git log --oneline (git describe --tags --abbrev=0 @^)..@";
      gw = "git switch";
      gm = "git switch (git main-branch)";
      gms = "git switch (git main-branch); and git sync";
      egms = "e; git switch (git main-branch); and git sync";
      gwc = "git switch -c";
      gpr = "git ppr";

      # kubectl
      kx = "kubectx";
      kn = "kubens";
      k = "kubectl";
      sk = "kubectl -n kube-system";
      kg = "kubectl get";
      kgp = "kubectl get po";
      kga = "kubectl get --all-namespaces";
      kd = "kubectl describe";
      kdp = "kubectl describe po";
      krm = "kubectl delete";
      ke = "kubectl edit";
      kex = "kubectl exec -it";
      kdebug = ''
        kubectl run -i -t debug --rm --image=caarlos0/debug --restart=Never
      '';
      knrunning = "kubectl get pods --field-selector=status.phase!=Running";
      kfails = ''
        kubectl get po -owide --all-namespaces | grep "0/" | tee /dev/tty | wc -l
      '';
      kimg = ''
        kubectl get deployment --output=jsonpath='{.spec.template.spec.containers[*].image}'
      '';
      kvs = "kubectl view-secret";
      kgno = "kubectl get no --sort-by=.metadata.creationTimestamp";
      kdrain = "kubectl drain --ignore-daemonsets --delete-local-data";

      # neovim
      e = "code -n";
      v = "nvim";

      # terraform
      tf = "terraform";

      freeze = "freeze -c full";

      # mods
      gcai = "git --no-pager diff | mods 'write a commit message for this patch. also write the long commit message. use semantic commits. break the lines at 80 chars' >.git/gcai; git commit -a -F .git/gcai -e";
    };
  };

  xdg.configFile."fish/themes/catppuccin.theme" = {
    source = ./catppuccin.theme;
  };
}
