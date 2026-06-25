autoload -U colors && colors
#PROMPT='[%n@%m]%20<...<%<<$ '
#PROMPT='%F{green}%~%f%F{green}>%f '
#PROMPT='%F{green}%64<...<%~%<<%f%F{green}>%f '

setopt PROMPT_SUBST
PROMPT='%F{green}$(smart_pwd)%f%F{green}>%f '

smart_pwd() {
    local pwd_str="${PWD/#$HOME/~}"
    if [[ ${#pwd_str} -gt 64 ]]; then
        echo "...${pwd_str: -61}"
    else
        echo "$pwd_str"
    fi
}


LS_COLORS="di=38;2;240;120;80:fi=0:*.jpg=38;2;90;140;200:*.jpeg=38;2;90;140;200:*.jxl=38;2;90;140;200
          .png=38;2;90;140;200:*.gif=38;2;90;140;200:*.bmp=38;2;90;140;200:*
          .svg=38;2;90;140;200:*.pdf=38;2;200;200;200"
export LS_COLORS

HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.cache/zsh/history
export GPG_TTY=$(tty)

autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots)

# vi mode
bindkey -v
export KEYTIMEOUT=1
export EDITOR='nvim'
export VISUAL='nvim'

# aliases
alias nv='nvim'
alias de='doasedit'
alias reboot='doas reboot'
alias poweroff='doas poweroff'
alias xi='doas xbps-install'
alias xr='doas xbps-remove'
alias xq='xbps-query'
alias cat='bat'
#alias ls='ls --color=auto -X'

# git aliases
alias gs='git status --short'
alias ga='git add'
alias gap='ga --patch'
alias gb='git branch'
alias gba='gb --all'
alias gc='git commit'
alias gca='gc --amend --no-edit'
alias gce='gc --amend'
alias gco='git checkout'
alias gcl='git clone --recursive'
alias gd='git diff --output-indicator-new=" " --output-indicator-old=" "'
alias gds='gd --staged'
alias gi='git init'
alias gl='git log --graph --all --pretty=format:"%C(magenta)%h %C(white) %an  %ar%C(auto)  %D%n%s%n"'
alias gm='git merge'
alias gn='git checkout -b'  # new branch
alias gp='git push'
alias gr='git reset'
alias gs='git status --short'
alias gu='git pull'
alias gw='git switch'

# portage aliases
alias makeconf='doasedit /etc/portage/make.conf'
alias dispatch-conf='doas dispatch-conf'
alias emerge='doas emerge'
alias eselect='doas eselect'
alias eclean-dist='doas eclean-dist'
alias eclean-kernel='doas eclean-kernel'
alias eclean-pkg='doas eclean-pkg'
alias ecleand='doas eclean-pkg -d; doas eclean-dist -d; doas eclean-kernel -n 1' 
alias ecleandp='doas eclean-pkg -dp; doas eclean-dist -dp; doas eclean-kernel -p -n 1' 
alias es='doas emerge --search' 
alias ei='doas emerge -av' 
alias ess='doas emerge --sync'
alias eu='doas emerge -avuDN @world'

# nix aliases
alias nix-install='doas nix-env -iA nixpkgs.'
alias nix-search='doas nix search nixpkgs'
alias nix-upgrade='doas nix-env -u'
alias nix-remove='doas nix-env -e'
alias nix-list='doas nix-env -q'
alias nix-show='doas nix-env -qa --description'
alias nix-clear='doas nix-collect-garbage -d'

# Use vim keys in tab complete menu:
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -v '^?' backward-delete-char


autoload edit-command-line; zle -N edit-command-line
bindkey '^e' edit-command-line

# Change cursor shape for different vi modes.
function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]] ||
     [[ $1 = 'block' ]]; then
    echo -ne '\e[1 q'
  elif [[ ${KEYMAP} == main ]] ||
       [[ ${KEYMAP} == viins ]] ||
       [[ ${KEYMAP} = '' ]] ||
       [[ $1 = 'beam' ]]; then
    echo -ne '\e[5 q'
  fi
}
zle -N zle-keymap-select
zle-line-init() {
    zle -K viins # initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
    echo -ne "\e[5 q"
}
zle -N zle-line-init
echo -ne '\e[5 q' # Use beam shape cursor on startup.
preexec() { echo -ne '\e[5 q' ;} # Use beam shape cursor for each new prompt.

export PATH="$HOME/.cargo/bin:$PATH"
if [ -f "$HOME/.nix-profile/etc/profile.d/nix.sh" ]; then
    . "$HOME/.nix-profile/etc/profile.d/nix.sh"
fi

if [ -f /usr/share/zsh/site-functions/zsh-syntax-highlighting.zsh ]; then
    source /usr/share/zsh/site-functions/zsh-syntax-highlighting.zsh
elif [ -f /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
    source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

if [ "$(tty)" = "/dev/tty1" ]; then
    #exec dbus-run-session sway --unsupported-gpu
    dbus-run-session niri --session
fi

# Created by `pipx` on 2026-03-05 15:29:36
export PATH="$PATH:/home/user/.local/bin"
