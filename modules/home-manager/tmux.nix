{
  config,
  lib,
  pkgs,
  ...
}: {
  options = {
    crony.tmux.enable = lib.mkEnableOption "Enable tmux and customize it";
  };

  config = lib.mkIf config.crony.tmux.enable {
    programs.tmux = {
      enable = true;
      escapeTime = 0;
      keyMode = "vi";
      prefix = "C-Space";

      extraConfig = ''
        # start window and panes indexing at 1
        set -g base-index 1
        set -g pane-base-index 1
        set-window-option -g pane-base-index 1
        set-option -g renumber-windows on

        # SPEED
        set-option -g status-interval 1

        # set vi-mode
        set-window-option -g mode-keys vi
        # keybindings
        bind-key -T copy-mode-vi v send-keys -X begin-selection
        bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle
        bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel

        bind "'" split-window -v -c "#{pane_current_path}"
        bind '\' split-window -h -c "#{pane_current_path}"

        # Vim keybindings for pane movement
        setw -g mode-keys vi
        bind-key h select-pane -L
        bind-key j select-pane -D
        bind-key k select-pane -U
        bind-key l select-pane -R

        # Skip kill pane %Number% (y/n) prompt
        bind-key x kill-pane

        # Don't exit from tmux when closing a session
        set -g detach-on-destroy off

        # Bar to top
        set-option -g status-position top

        # sesh for session management
        bind-key "T" run-shell "sesh connect \"$(
          sesh list --icons | fzf-tmux -p 55%,60% \
            --no-sort --ansi --border-label ' sesh ' --prompt '⚡  ' \
            --header '  ^a all ^t tmux ^g configs ^x zoxide ^d tmux kill ^f find' \
            --bind 'tab:down,btab:up' \
            --bind 'ctrl-a:change-prompt(⚡  )+reload(sesh list --icons)' \
            --bind 'ctrl-t:change-prompt(🪟  )+reload(sesh list -t --icons)' \
            --bind 'ctrl-g:change-prompt(⚙️  )+reload(sesh list -c --icons)' \
            --bind 'ctrl-x:change-prompt(📁  )+reload(sesh list -z --icons)' \
            --bind 'ctrl-f:change-prompt(🔎  )+reload(fd -H -d 2 -t d -E .Trash . ~)' \
            --bind 'ctrl-d:execute(tmux kill-session -t {2..})+change-prompt(⚡  )+reload(sesh list --icons)' \
        )\""

        bind-key "n" run-shell "sesh connect nnn"

        # use sesh for last session
        bind -N "last-session (via sesh) " L run-shell "sesh last"
      '';

      plugins = with pkgs; [
        tmuxPlugins.sensible
        tmuxPlugins.yank
        tmuxPlugins.fzf-tmux-url
      ];
    };
  };
}
