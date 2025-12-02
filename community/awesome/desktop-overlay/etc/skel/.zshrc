# Use powerline
USE_POWERLINE="true"
# Has weird character width
# Example:
#    is not a diamond
HAS_WIDECHARS="false"
# Source manjaro-zsh-configuration
if [[ -e /usr/share/zsh/manjaro-zsh-config ]]; then
  source /usr/share/zsh/manjaro-zsh-config
fi
# Use manjaro zsh prompt
#if [[ -e /usr/share/zsh/manjaro-zsh-prompt ]]; then
#  source /usr/share/zsh/manjaro-zsh-prompt
#fi

# 1. Zsh Autosuggestions visszapótlása (mert ez a prompt fájlban volt)
if [ -f /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
    source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
    ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=244' # Szürke szín beállítása
fi

# Oh My Posh indítása - NORDTRON témával blueish powerlevel10k_classic
# Közvetlenül a rendszerfájlra hivatkozunk, így nem lesz hibaüzenet
if command -v oh-my-posh &> /dev/null; then
    eval "$(oh-my-posh init zsh --config /usr/share/oh-my-posh/themes/nordtron.omp.json)"
fi


# =============================================================================
# Fish konfigurációból átvett aliasok és funkciók
# =============================================================================

# eza aliasok
alias ls="eza -al --color=always --group-directories-first --icons"
alias la="eza -a --color=always --group-directories-first --icons" 
alias ll="eza -l --color=always --group-directories-first --icons"
alias lt="eza -aT --color=always --group-directories-first --icons"
alias l.="eza -ald --color=always --group-directories-first --icons .*"

# bat alias
alias cat="bat --style header --style snip --style changes --style header"

# Arch specifikus aliasok
alias upd="pamac update --no-confirm"
alias pacdiff="sudo -H DIFFPROG=meld pacdiff"
alias jctl="journalctl -p 3 -xb"

# Funkciók
backup() {
    cp "$1" "$1.bak"
    echo "Backup created: $1.bak"
}

copy() {
    if [ $# -eq 2 ] && [ -d "$1" ]; then
        local from="${1%/}"
        local to="$2"
        command cp -r "$from" "$to"
    else
        command cp "$@"
    fi
}


# =============================================================================
# Fish konfigurációból átvett beállítások
# =============================================================================

# Környezeti változók
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
export MANROFFOPT="-c"

# Qt theme beállítás
if command -v qtile > /dev/null 2>&1; then
    export QT_QPA_PLATFORMTHEME="qt5ct"
fi

# PATH beállítások
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/Applications/depot_tools:$PATH"

# Aliasok a fish konfigurációból

# eza aliasok - FELÜLÍRJUK a manjaro ls aliasát
alias ls="eza -al --color=always --group-directories-first --icons"
alias lsz="eza -al --color=always --total-size --group-directories-first --icons"
alias la="eza -a --color=always --group-directories-first --icons"
alias ll="eza -l --color=always --group-directories-first --icons"
alias lt="eza -aT --color=always --group-directories-first --icons"
alias l.="eza -ald --color=always --group-directories-first --icons .*"

# bat alias
alias cat="bat --style header --style snip --style changes --style header"

# ugrep aliasok
alias grep="ugrep --color=auto"
alias egrep="ugrep -E --color=auto"
alias fgrep="ugrep -F --color=auto"

# Könyvtár navigáció
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ......="cd ../../../../.."

# Arch Linux specifikus aliasok
alias big="expac -H M '%m\t%n' | sort -h | nl"
alias dir="dir --color=auto"
alias fixpacman="sudo rm /var/lib/pacman/db.lck"
alias gitpkg="pacman -Q | grep -i '\-git' | wc -l"
alias grubup="sudo update-grub"
alias hw="hwinfo --short"
alias ip="ip -color"
alias psmem="ps auxf | sort -nr -k 4"
alias psmem10="ps auxf | sort -nr -k 4 | head -10"
alias rmpkg="sudo pacman -Rdd"
alias tarnow="tar -acf "
alias untar="tar -zxvf "
alias upd="pamac update --no-confirm"
alias vdir="vdir --color=auto"
alias wget="wget -c"


# Segítő aliasok
alias apt="man pacman"
alias apt-get="man pacman"
alias please="sudo"
alias tb="nc termbin.com 9999"
alias helpme="echo 'To print basic information about a command use helpme <command>'"
alias pacdiff="sudo -H DIFFPROG=meld pacdiff"
alias jctl="journalctl -p 3 -xb"
alias rip="expac --timefmt='%Y-%m-%d %T' '%l\t%n %v' | sort | tail -200 | nl"

# Funkciók a fish konfigurációból
backup() {
    cp "$1" "$1.bak"
}

copy() {
    local count=$#
    if [ "$count" -eq 2 ] && [ -d "$1" ]; then
        local from=$(echo "$1" | sed 's:/*$::')
        local to="$2"
        command cp -r "$from" "$to"
    else
        command cp "$@"
    fi
}

cleanup() {
    while true; do
        local orphans=$(pacman -Qdtq)
        if [ -z "$orphans" ]; then
            break
        fi
        sudo pacman -Rs $orphans
        if [ $? -eq 1 ]; then
            break
        fi
    done
}

# Starship prompt inicializálás
#if command -v starship > /dev/null 2>&1; then
#    eval "$(starship init zsh)"
#fi

# Fastfetch indítása interaktív sessionben (KIVÉVE ha Quake módban vagyunk)
if [[ -o interactive ]] && [[ -z "$QUAKE_MODE" ]] && command -v fastfetch > /dev/null 2>&1; then
    fastfetch --config neofetch.jsonc 2>/dev/null || fastfetch
fi

# Command-not-found hook (ha elérhető)
if [ -f /usr/share/doc/find-the-command/ftc.zsh ]; then
    source /usr/share/doc/find-the-command/ftc.zsh
fi

# Fish beállítások vége

# =============================================================================
# Fish konfigurációból átvett aliasok és funkciók
# =============================================================================

# eza aliasok
alias ls="eza -al --color=always --group-directories-first --icons"
alias la="eza -a --color=always --group-directories-first --icons" 
alias ll="eza -l --color=always --group-directories-first --icons"
alias lt="eza -aT --color=always --group-directories-first --icons"
alias l.="eza -ald --color=always --group-directories-first --icons .*"

# bat alias
alias cat="bat --style header --style snip --style changes --style header"

# Arch specifikus aliasok
alias upd="pamac update --no-confirm"
alias pacdiff="sudo -H DIFFPROG=meld pacdiff"
alias jctl="journalctl -p 3 -xb"

# Funkciók
backup() {
    cp "$1" "$1.bak"
    echo "Backup created: $1.bak"
}

copy() {
    if [ $# -eq 2 ] && [ -d "$1" ]; then
        local from="${1%/}"
        local to="$2"
        command cp -r "$from" "$to"
    else
        command cp "$@"
    fi
}
if [ $TILIX_ID ] || [ $VTE_VERSION ]; then
        source /etc/profile.d/vte.sh
fi
