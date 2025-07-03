# Start tmux if not already inside a tmux session
if [[ -z "$TMUX" ]]; then
  tmux
fi

setopt promptsubst interactivecomments \
  hist_ignore_all_dups inc_append_history \
  autocd autopushd pushdminus pushdsilent pushdtohome cdablevars \
  extendedglob

unsetopt nomatch  # Allow [ or ] anywhere

# Completion setup
fpath=(~/.zsh/completion /usr/local/share/zsh/site-functions $fpath)
autoload -U compinit colors
compinit -u
colors

# Load custom functions
for function in ~/.zsh/functions/*; do
  source "$function"
done

# Enable colored output
export CLICOLOR=1

# History settings
HISTFILE=~/.zhistory
HISTSIZE=4096
SAVEHIST=4096
DIRSTACKSIZE=5

# Keybindings
bindkey -v
bindkey "^F" vi-cmd-mode
bindkey jj vi-cmd-mode
bindkey "^A" beginning-of-line
bindkey "^E" end-of-line
bindkey "^K" kill-line
bindkey "^R" history-incremental-search-backward
bindkey "^P" history-search-backward
bindkey "^Y" accept-and-hold
bindkey "^N" insert-last-word
bindkey -s "^T" "^[Isudo ^[A" # "t" for "toughguy"

set -o nobeep  # no annoying beeps

# Aliases
[[ -f ~/.aliases ]] && source ~/.aliases

# Theme
source ~/.zsh/themes/peepcode.theme

# Syntax highlighting
source ~/.zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

export TERM=screen-256color

# Local config and secrets
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local
[[ -f ~/.secrets ]] && source ~/.secrets

# RVM setup
if [[ -s "$HOME/.rvm/scripts/rvm" ]]; then
  source "$HOME/.rvm/scripts/rvm"
  export PATH="$PATH:$HOME/.rvm/bin"
fi

# NVM setup
export NVM_DIR="$HOME/.nvm"
if [[ -s "$NVM_DIR/nvm.sh" ]]; then
  source "$NVM_DIR/nvm.sh"
fi
if [[ -s "$NVM_DIR/bash_completion" ]]; then
  source "$NVM_DIR/bash_completion"
fi

# Go binary path
export PATH="$PATH:/usr/local/go/bin"
