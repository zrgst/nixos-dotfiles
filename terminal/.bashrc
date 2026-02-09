export PATH="$HOME/.local/bin:$PATH"
# ----- History -----
HISTSIZE=5000
HISTFILESIZE=10000
HISTCONTROL=ignoredups:erasedups
HISTIGNORE="ls:cd:pwd:clear:history"
shopt -s histappend cmdhist

# ----- Prompt (simple but useful) -----
# Show: user@host:cwd (git-branch) $
parse_git_branch() {
    git branch --show-current 2>/dev/null
}
PS1='\[\e[1;32m\]\u@\h \[\e[0;33m\]\w\[\e[0;36m\]$(git branch --show-current 2>/dev/null | sed "s/^/ (/;s/$/)/")\[\e[0m\]\n\$ '

# ----- Colors -----
if [[ $TERM != "dumb" ]]; then
    export LS_OPTIONS='--color=auto'
    alias ls='ls $LS_OPTIONS'
    alias ll='ls $LS_OPTIONS -lh'
    alias la='ls $LS_OPTIONS -lha'
fi

# ----- Useful defaults -----
set -o vi # or comment this out if you prefer emacs-style
shopt -s checkwinsize
shopt -s autocd # `cd` by just typing directory name

# ----- Bash completion -----
if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
        . /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
    fi
fi

# ----- fzf integration (simple) -----
# Ctrl-R: fuzzy search history
if command -v fzf >/dev/null 2>&1; then
    __fzf_history() {
        builtin fc -l 1 | fzf +s --tac | sed 's/^[[:space:]]*[0-9]\+[[:space:]]*//' | tr -d '\n' | xargs -0 printf '%s'
    }
    bind '"\er": "\C-e\C-u$(__fzf_history)\e\C-e\er"'
fi

# ----- Your own aliases / functions -----
# Move any aliases you like from zsh:
# alias gs='git status'
alias ..='cd ..'
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'
alias ls="ls --color"
alias c="clear"
alias bilde='swayimg'
alias bilder="swayimg ."
# Case-insensitive tab completion
bind 'set completion-ignore-case on'
bind 'set show-all-if-ambiguous on'
bind 'set show-all-if-unmodified on'
alias finalrecon="docker run -it --rm --name finalrecon  --entrypoint 'python3' thewhiteh4t/finalrecon finalrecon.py"
# Legger til min lokale bin-mappe i PATH

# Starter bibel-appen min
#biblefetch

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion
