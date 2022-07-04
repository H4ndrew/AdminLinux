# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=10000000
HISTFILESIZE=200000000

# print timestamp for each command in history
HISTTIMEFORMAT="%F %T "

# export history from each terminal to save all terminals commands
export PROMPT_COMMAND='history -a'

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
#[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
        # We have color support; assume it's compliant with Ecma-48
        # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
        # a case would tend to support setf rather than setaf.)
        color_prompt=yes
    else
        color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    #PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$'
    PS1='\e[0;34m\n[\t] \e[0;31m\u@\h \e[0;32m\w\n\$'
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -lah'
alias sll='sudo ls -lah'
alias la='ls -A'
alias l='ls -CF'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# Common Aliases
alias rm='rm -iv --preserve-root'
alias cp='cp -iv'
alias mv='mv -iv'
alias chown='chown --preserve-root'
alias chmod='chmod --preserve-root'
alias chgrp='chgrp --preserve-root'
alias meminfo='free -m -l -t'
alias wget='wget -c --show-progress'
alias df='df -h'
alias python='python3'
alias pip='pip 3'
alias cls='clear'
alias bashrc='nano ~/.bashrc'
alias conf='source ~/.bashrc'

# Docker Aliases
alias mydls='docker ps -a | grep `(whoami)`'
alias dlog='docker logs --tail 50'
alias dlogf='docker logs -f'
alias dls='docker ps -a'
alias dnco='docker network connect'
alias dnls='docker network ls'
alias dnlsc='docker network inspect --format '\''{{ range $key, $value := .Containers }}{{ printf "%s\n" .Name}}{{ end }}'\'''
alias dsp='docker system prune --all'
alias vsc='dexec vsc-arun'
alias super_vsc='dexecsu vsc-arun'
alias jupyter='dexec jupyter-arun'
alias super_jupyter='dexecsu jupyter-arun'

dexec() {
    docker exec -it "${1}" /bin/sh -c "[ -e /bin/bash ] && /bin/bash || /bin/sh"
}

dexecsu() {
    docker exec -itu root "${1}" /bin/sh -c "[ -e /bin/bash ] && /bin/bash || /bin/sh"
}

#Systemd Aliases
alias services='ls /etc/systemd/system/ -lah'
alias uservices='ls ~/.config/systemd/user/ -lah'
alias sureload='systemctl --user daemon-reload'
alias surestart='systemctl --user restart'
alias sustart='systemctl --user start'
alias sreload='systemctl daemon-reload'
alias srestart='systemctl restart'

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
        . /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
    fi
fi
