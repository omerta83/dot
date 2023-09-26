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
# export FZF_DEFAULT_COMMAND='rg --files --ignore --hidden --follow -g "!{.git,node_modules}/*" 2> /dev/null'
export FZF_DEFAULT_COMMAND='fd --type file --hidden --ignore'
export FZF_DEFAULT_OPTS=" \
--no-separator \
--bind ctrl-y:preview-up,ctrl-e:preview-down,ctrl-b:preview-page-up,ctrl-f:preview-page-down,ctrl-u:preview-half-page-up,ctrl-d:preview-half-page-down,shift-up:preview-top,shift-down:preview-bottom,alt-up:half-page-up,alt-down:half-page-down"
# catppuccin
# export FZF_DEFAULT_OPTS = "$FZF_DEFAULT_OPTS"\
# "--color=bg+:#313244,bg:#000000,spinner:#f5e0dc,hl:#f38ba8 \
# --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc,gutter:#000000 \
# --color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8"
# tokyonight
export FZF_DEFAULT_OPTS=$FZF_DEFAULT_OPTS' 
	--color=fg:#c0caf5,bg:#1a1b26,hl:#bb9af7
	--color=fg+:#c0caf5,bg+:#1a1b26,hl+:#7dcfff
	--color=info:#7aa2f7,prompt:#7dcfff,pointer:#7dcfff 
	--color=marker:#9ece6a,spinner:#9ece6a,header:#9ece6a'

export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
# export FZF_CTRL_T_OPTS="--preview '(highlight -O ansi -l {} 2> /dev/null || cat {} || tree -C {}) 2> /dev/null | head -200'"
export FZF_CTRL_T_OPTS="--preview 'bat --color=always --style=numbers --line-range :500 {}'"
export FZF_ALT_C_OPTS="--preview 'tree -C {} | head -200'"

export XDG_CONFIG_HOME="$HOME/.config"

# Use nvim as manpager
export MANPAGER='nvim +Man!'
export MANWIDTH=999

# Not share command history between tmux panes
setopt noincappendhistory
setopt nosharehistory

export VOLTA_HOME="$HOME/.volta"
export PNPM_HOME="$HOME/.pnpm"
export PATH="$PATH:$HOME/.local/flutter/bin:$HOME/.yarn/bin:$VOLTA_HOME/bin:$PNPM_HOME:/Applications/WezTerm.app/Contents/MacOS:$HOME/.local/bin"

eval "$(zoxide init zsh)"
eval "$(starship init zsh)"

export STARSHIP_CONFIG=~/.config/starship/starship.toml

source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/.zsh/zsh-vi-mode/zsh-vi-mode.zsh
export PATH="/opt/homebrew/opt/curl/bin:$PATH"
alias lzd='lazydocker'

# Use tab for autocomplete
# bindkey '^I' autosuggest-accept # tab
# bindkey '^[[Z' complete-word # shift + tab
