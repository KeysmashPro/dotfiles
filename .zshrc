autoload -U colors && colors
PROMPT='[%n@%m]%20<...<%<<$ ' PROMPT='%F{green}%~%f%F{green}>%f '
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.cache/zsh/history

autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots)

# vi mode
bindkey -v
export KEYTIMEOUT=1

# aliases
alias shutdown='shutdown now'
alias poweroff='doas poweroff'
alias reboot='doas reboot'
alias nv='bob run nightly'
alias dnv='doas bob run nightly'
alias xi='doas xbps-install'
alias xr='doas xbps-remove -R'
alias xq='xbps-query'
alias gs='git status --short'

# portage aliases
alias makeconf='doas bob run nightly /etc/portage/make.conf'
alias dispatch-conf='doas dispatch-conf'
alias emerge='doas emerge'
alias eselect='doas eselect'
alias eclean-dist='doas eclean-dist'
alias eclean-kernel='doas eclean-kernel'
alias eclean-pkg='doas eclean-pkg'
alias ecleand='doas eclean-pkg -d; doas eclean-dist -d; doas eclean-kernel -n 1' alias ecleandp='doas eclean-pkg -dp; doas eclean-dist -dp; doas eclean-kernel -p -n 1' alias es='doas emerge --search' alias ei='doas emerge -av' alias ess='doas emerge --sync'
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

export EDITOR='nvim'
export VISUAL='nvim'

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
    exec dbus-run-session sway --unsupported-gpu
fi

# Created by `pipx` on 2026-03-05 15:29:36
export PATH="$PATH:/home/user/.local/bin"


# Modified Luke Smith config file
