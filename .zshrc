## vi Keybinding
bindkey -v

## Completion
autoload -U compinit; compinit
# Search sbin when sudoing.
zstyle ':completion:*:sudo::' environ PATH="/sbin:/usr/sbin:$PATH"
# Coloring
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

## glob
# Append a trailing `/' to all directory names resulting from filename generation (globbing).
setopt mark_dirs
# Treat the `#', `~' and `^' characters as part of patterns for filename generation, etc.  (An initial unquoted `~' always produces named directory expansion.)
# Disabled, sicne it is inconvinient with git.
#setopt extended_glob

## interaction
# opts
setopt autocd auto_pushd correct interactivecomments nobeep
# Command line stack.
bindkey '^T' push-line-or-edit

## Prompt
# color
autoload colors; colors
# "<user>:<current dir:cyan>% "
PROMPT="$USER:%{$fg[cyan]%}%~%{$reset_color%}%% "
# If ssh-connected, push "<host:white> "
[[ -n "${REMOTEHOST}${SSH_CONNECTION}${KUBERNETES_SERVICE_HOST}" ]] &&
    PROMPT="%{${fg[white]}%}${HOST%%.*}%{$reset_color%} ${PROMPT}"

## History
function zshaddhistory() {
    emulate -L zsh
    if [[ $1 = "shred"* ]]; then
        return 1
    fi
}

HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
# This option both imports new commands from the history file, and also causes your typed commands to be appended to the history file
# (the latter is like specifying INC_APPEND_HISTORY, which should be turned off if this option is in effect).
setopt share_history
# If a new command line being added to the history list duplicates an older one, the older command is removed from the list (even if it is not the previous event).
setopt hist_ignore_all_dups
# Search history when the cursor is on the end.
#bindkey "^P" history-incremental-search-backward
#bindkey "^N" history-incremental-search-forward
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^P" history-beginning-search-backward-end
bindkey "^N" history-beginning-search-forward-end

## Commands
# aliases
alias ls='ls --color=auto' # should be overridden on non-GNU env
alias grep='grep --color=auto' # should be overridden on non-GNU env
alias rol='ruby -p -e'
alias tmux='tmux -2'
alias gvimr='gvim --remote-tab-silent'

# home bin
export PATH=~/bin:$PATH
export PATH="${HOME}/.local/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"

# rubygems
if which ruby >/dev/null && which gem >/dev/null; then
    export PATH="$(ruby -r rubygems -e 'puts Gem.user_dir')/bin:$PATH"
fi

# virtualenvwrapper
if which virtualenvwrapper.sh > /dev/null && which virtualenvwrapper_lazy.sh > /dev/null; then
    export WORKON_HOME=$HOME/.virtualenvs
    export PROJECT_HOME=$HOME
    export VIRTUALENVWRAPPER_SCRIPT="$(which virtualenvwrapper.sh)"
    source "$(which virtualenvwrapper_lazy.sh)"
fi

# Gcloud
[[ -f "${HOME}/google-cloud-sdk/path.zsh.inc" ]] && source "${HOME}/google-cloud-sdk/path.zsh.inc"
[[ -f "${HOME}/google-cloud-sdk/completion.zsh.inc" ]] && source "${HOME}/google-cloud-sdk/completion.zsh.inc"

## Load per machine config if available.
[[ -f ~/.zshmod ]] && source ~/.zshmod
