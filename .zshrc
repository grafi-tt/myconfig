## vi Keybinding
bindkey -v

## Commands
# aliases
alias ls='ls --color=auto' # should be overridden on non-GNU env
alias grep='grep --color=auto' # should be overridden on non-GNU env
alias rol='ruby -p -e'
alias tmux='tmux -2'
alias gvimr='gvim --remote-tab-silent'
# home bin
export PATH=~/bin:$PATH

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
# Try to correct the spelling of commands.
setopt correct
# No beep on error.
setopt nobeep
# Command line stack.
bindkey '^T' push-line-or-edit

## Chdir
# If a command is issued that can't be executed as a normal command, and the command is the name of a directory, perform the cd command to that directory.
setopt auto_cd
# Make cd push the old directory onto the directory stack.
setopt auto_pushd

## Prompt
# color
autoload colors; colors
# "<user>:<current dir:cyan>% "
PROMPT="$USER:%{$fg[cyan]%}%~%{$reset_color%}%% "
# If ssh-connected, push "<host:white> "
[[ -n "${REMOTEHOST}${SSH_CONNECTION}${KUBERNETES_SERVICE_HOST}" ]] &&
	PROMPT="%{${fg[white]}%}${HOST%%.*}%{$reset_color%} ${PROMPT}"

## History
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

alias yanaconda="source $HOME/miniconda3/bin/activate"
