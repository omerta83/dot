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

local color00='#1d2021'
local color01='#3c3836'
local color02='#504945'
local color03='#665c54'
local color04='#bdae93'
local color05='#d5c4a1'
local color06='#ebdbb2'
local color07='#fbf1c7'
local color08='#fb4934'
local color09='#fe8019'
local color0A='#fabd2f'
local color0B='#b8bb26'
local color0C='#8ec07c'
local color0D='#83a598'
local color0E='#d3869b'
local color0F='#d65d0e'

# export FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow -g "!{.git,node_modules}/*" 2> /dev/null'
export FZF_DEFAULT_COMMAND='rg --files --ignore --hidden --follow -g "!{.git,node_modules}/*" 2> /dev/null'
export FZF_DEFAULT_OPTS=" \
--no-separator \
--bind ctrl-y:preview-up,ctrl-e:preview-down,ctrl-b:preview-page-up,ctrl-f:preview-page-down,ctrl-u:preview-half-page-up,ctrl-d:preview-half-page-down,shift-up:preview-top,shift-down:preview-bottom,alt-up:half-page-up,alt-down:half-page-down"
# export FZF_DEFAULT_OPTS = "$FZF_DEFAULT_OPTS"\
# "--color=bg+:#313244,bg:#000000,spinner:#f5e0dc,hl:#f38ba8 \
# --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc,gutter:#000000 \
# --color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8"
export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS"\
" --color=bg+:$color01,bg:$color00,spinner:$color0C,hl:$color0D"\
" --color=fg:$color04,header:$color0D,info:$color0A,pointer:$color0C,gutter:$color00"\
" --color=marker:$color0C,fg+:$color06,prompt:$color0A,hl+:$color0D"

export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
# export FZF_CTRL_T_OPTS="--preview '(highlight -O ansi -l {} 2> /dev/null || cat {} || tree -C {}) 2> /dev/null | head -200'"
export FZF_CTRL_T_OPTS="--preview 'bat --color=always --style=numbers --line-range :500 {}'"
export FZF_ALT_C_OPTS="--preview 'tree -C {} | head -200'"

export XDG_CONFIG_HOME="$HOME/.config"
export TERM="xterm-kitty"

# Use nvim as manpager
export MANPAGER='nvim +Man!'
export MANWIDTH=999

# Not share command history between tmux panes
setopt noincappendhistory
setopt nosharehistory

export VOLTA_HOME="$HOME/.volta"
export PNPM_HOME="$HOME/.pnpm"
export PATH="$PATH:$HOME/.local/flutter/bin:$HOME/.yarn/bin:$VOLTA_HOME/bin:$PNPM_HOME"

eval "$(zoxide init zsh)"
eval "$(starship init zsh)"

export STARSHIP_CONFIG=~/.config/starship/starship.toml

source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/.zsh/zsh-vi-mode/zsh-vi-mode.zsh
export PATH="/opt/homebrew/opt/curl/bin:$PATH"
alias lzd='lazydocker'

# Use tab for autocomplete
bindkey '^I' autosuggest-accept # tab
bindkey '^[[Z' complete-word # shift + tab
