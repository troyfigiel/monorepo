{ config, lib, ... }:

let inherit (lib) mkEnableOption mkIf mkMerge;
in {
  options.my.fish.enable = mkEnableOption "fish";

  config = mkIf config.my.fish.enable (mkMerge [{
    programs.fish = {
      enable = true;
      useBabelfish = true;

      shellAliases = {
        ls = "ls --color=auto -h";
        grep = "grep --color=auto";
        mv = "mv -i"; # Ask before overwriting
      };

      shellAbbrs = {
        lg = "lazygit";
        ec = "emacsclient -cn";
        et = "emacsclient -t";

        nd = "nix run .#deploy";
        nr = "nix run";
        np = "nix shell nixpkgs#";
      };

      functions = {
        fish_greeting = "";
        # fish_prompt = ''
        #   function fish_prompt --description 'Write out the prompt'
        #       set -l last_pipestatus $pipestatus
        #       set -lx __fish_last_status $status # Export for __fish_print_pipestatus.
        #       set -l normal (set_color normal)
        #       set -q fish_color_status
        #       or set -g fish_color_status --background=red white

        #       # Color the prompt differently when we're root
        #       set -l color_cwd $fish_color_cwd
        #       set -l suffix '>'
        #       if functions -q fish_is_root_user; and fish_is_root_user
        #           if set -q fish_color_cwd_root
        #               set color_cwd $fish_color_cwd_root
        #           end
        #           set suffix '#'
        #       end

        #       # Write pipestatus
        #       # If the status was carried over (if no command is issued or if `set` leaves the status untouched), don't bold it.
        #       set -l bold_flag --bold
        #       set -q __fish_prompt_status_generation; or set -g __fish_prompt_status_generation $status_generation
        #       if test $__fish_prompt_status_generation = $status_generation
        #           set bold_flag
        #       end
        #       set __fish_prompt_status_generation $status_generation
        #       set -l status_color (set_color $fish_color_status)
        #       set -l statusb_color (set_color $bold_flag $fish_color_status)
        #       set -l prompt_status (__fish_print_pipestatus "[" "]" "|" "$status_color" "$statusb_color" $last_pipestatus)

        #       echo -n -s (prompt_login)' ' (set_color $color_cwd) (prompt_pwd) $normal (fish_vcs_prompt) $normal " "$prompt_status $suffix " "
        #   end
        # '';
      };
      interactiveShellInit = let
        terminalColors = ''
          # Colors, uses terminal ones
          set fish_color_user                   green
          set fish_color_cwd                    blue
          set fish_color_error                  red

          # Colors for prompt
          set prompt_color_arrow                '-o' 'black'
          set prompt_color_current_folder       green

          # Colors for git prompt
          set git_prompt_color_separator        '-o' 'black'
          set git_prompt_color_branch           green
          set git_prompt_color_commit           '-o' 'black'
        '';
      in terminalColors;
    };

    programs.fzf = {
      enable = true;
      enableFishIntegration = true;
    };
  }

  # TODO: For some reason this does not work nicely. After a while during my session, the symlink has been replaced by a completely new .zsh_history file.
  # I am not sure why that happens.
  # (optionalAttrs impermanence {
  #   home.persistence."/nix/persist/${config.home.homeDirectory}" = {
  #     files = [ ".zsh_history" ];
  #     allowOther = true;
  #   };
  # })
    ]);
}
