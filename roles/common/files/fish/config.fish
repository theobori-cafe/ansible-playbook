if status is-interactive
    # Commands to run in interactive sessions can go here
end

alias la="exa -lahg"
alias tmux="tmux -2"
alias tf="terraform"
alias k="kubectl"

set -g PATH "$PATH:/$HOME/.local/bin"
set -g GPG_TTY (tty)

set -g theme_color_scheme dracula
