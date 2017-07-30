export PATH="/usr/local/texlive/2016/bin/x86_64-linux:$PATH"
export PATH="${HOME}/.local/bin:$PATH"
export LD_LIBRARY_PATH="/opt/intel/mkl/lib/intel64:/opt/intel/lib/intel64:$LD_LIBRARY_PATH"

# rubygems
if which ruby >/dev/null && which gem >/dev/null; then
    PATH="$(ruby -rubygems -e 'puts Gem.user_dir')/bin:$PATH"
fi

# virtualenv
if ! [ -z "${VIRTUAL_ENV}" ]; then
	PATH="$VIRTUAL_ENV/bin:$PATH"
	if [ -z "${VIRTUAL_ENV_DISABLE_PROMPT-}" ] ; then
		PS1="(`basename \"$VIRTUAL_ENV\"`) $PS1"
	fi
fi

## Load per machine config if available.
[[ -f ~/.zshmod ]] && source ~/.zshmod
