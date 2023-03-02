#
# Executes commands at the start of an interactive session.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

# Source Prezto.
# if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
#   source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
# fi

# Customize to your needs...

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# export FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow -g "!{.git,node_modules}/*" 2> /dev/null'
export FZF_DEFAULT_COMMAND='rg --files --ignore --hidden --follow -g "!{.git,node_modules}/*" 2> /dev/null'
export FZF_DEFAULT_OPTS='--color=gutter:#000000'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_CTRL_T_OPTS="--preview '(highlight -O ansi -l {} 2> /dev/null || cat {} || tree -C {}) 2> /dev/null | head -200'"
export FZF_ALT_C_OPTS="--preview 'tree -C {} | head -200'"

export XDG_CONFIG_HOME="$HOME/.config"

# Use nvim as manpager
export MANPAGER='nvim +Man!'
export MANWIDTH=999

# Not share command history between tmux panes
setopt noincappendhistory
setopt nosharehistory

export VOLTA_HOME="$HOME/.volta"
export PATH="$PATH:$HOME/.local/flutter/bin:$HOME/.yarn/bin:$VOLTA_HOME/bin"

eval "$(zoxide init zsh)"
eval "$(starship init zsh)"

export STARSHIP_CONFIG=~/.config/starship/starship.toml

source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/.zsh/zsh-vi-mode/zsh-vi-mode.zsh
export PATH="/opt/homebrew/opt/curl/bin:$PATH"
