args @ {pkgs, ...}: {
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting # disable greeting
    '';
    plugins = [
      {
        name = "tide";
        src = pkgs.fishPlugins.tide.src;
      }
      {
        name = "z";
        src = pkgs.fishPlugins.z.src;
      }
      {
        name = "puffer";
        src = pkgs.fishPlugins.puffer.src;
      }
      {
        name = "fzf-fish";
        src = pkgs.fishPlugins.fzf-fish.src;
      }
    ];
    shellAliases = {
      "ll" = "eza --long --git --header --icons";
      "lla" = "eza --long --git --header --icons -a";
    };
    shellInit = ''
      set -gx EDITOR nvim
      set -gx fzf_directors_opts --bind "ctrl-o:execute($EDITOR {} &> /dev/tty)"
      set -gx PF_INFO "ascii title os host kernel uptime memory wm palette"

      if command -q nix-your-shell
          nix-your-shell fish | source
      end
    '';

    functions = {
      fish_user_key_bindings = {
        body = "fish_vi_key_bindings";
      };

      fish_greeting = {
        body = "cd ~ && pfetch";
      };
      # yy = {
      #   body = ''
      #     set tmp (mktemp -t "yazi-cwd.XXXXXX")
      #     yazi $argv --cwd-file="$tmp"
      #     if set cwd (cat -- "$tmp"); and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
      #       cd -- "$cwd"
      #     end
      #     rm -f -- "$tmp"
      #   '';
      # };
    };
  };
}
