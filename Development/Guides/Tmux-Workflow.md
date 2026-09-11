# Tmux Workflow Notes

Standalone note. No links in or out. Prefix is Ctrl-b unless noted.

## Sessions

```bash
tmux new -s work
tmux ls
tmux attach -t work
tmux kill-session -t work
```

## Windows and Panes

```bash
c            # new window
,            # rename window
n p          # next prev window
%            # vertical split
"            # horizontal split
o            # cycle pane
x            # kill pane
z            # zoom pane fullscreen
```

## Copy Mode

```bash
[            # enter copy mode
space        # start selection (vi keys with setw -g mode-keys vi)
enter        # copy to buffer
]            # paste buffer
```

## Survival Config

```bash
set -g mouse on
setw -g mode-keys vi
set -g base-index 1
bind r source-file ~/.tmux.conf
```

## Remote Sessions

```bash
tmux -CC attach            # iTerm control mode
ssh -t host tmux attach -t work
```

- Nested tmux needs a second prefix, or run plain shells inside.
- Detach with `d`, sessions survive SSH drops and reboots of nothing except the host.

## Gotchas

- Scrollback defaults small, raise history-limit to 50000.
- Colors break without `set -g default-terminal tmux-256color`.
- Kill the server only when you mean all sessions: `tmux kill-server`.

## Tags
#note-tmux-workflow
