{
  config,
  inputs,
  pkgs,
  lib,
  ...
}: {
  options = {
    crony.tmux.enable = lib.mkEnableOption "Enable tmux and customize it";
  };

  config = lib.mkIf config.crony.tmux.enable {
    # Enable custom tmux bar settings
    home.sessionVariables = {
      TINTED_TMUX_OPTION_STATUSBAR = 1;
    };

    # Setup tmux
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
      '';

      plugins = with pkgs.tmuxPlugins; [
        sensible
        yank
        fzf-tmux-url
      ];
    };
  };
}
