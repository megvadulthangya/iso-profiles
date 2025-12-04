# =============================================================================
# KÖRNYEZETI VÁLTOZÓK (Environment Variables)
# =============================================================================

# PATH beállítások
export PATH="$HOME/.local/bin:$HOME/Applications/depot_tools:$PATH"

# Manpager (bat használata man olvasáshoz)
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
export MANROFFOPT="-c"

# Qt theme beállítás
if command -v qtile > /dev/null 2>&1; then
    export QT_QPA_PLATFORMTHEME="qt5ct"
fi

# =============================================================================
# MANJARO ALAPBEÁLLÍTÁSOK
# =============================================================================

# Use powerline
USE_POWERLINE="true"
# Has weird character width
HAS_WIDECHARS="false"

# Source manjaro-zsh-configuration
# Ez intézi a Syntax Highlightingot és az alap history keresést!
if [[ -e /usr/share/zsh/manjaro-zsh-config ]]; then
  source /usr/share/zsh/manjaro-zsh-config
fi

# =============================================================================
# PLUGINEK ÉS PROMPT
# =============================================================================

# 1. Zsh Autosuggestions (Szürke javaslatok)
if [ -f /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
    source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
    ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=244' 
fi

# 2. FZF (Fuzzy Finder) - EZT PÓTOLTAM!
# Ctrl+R-re bejön a szupergyors kereső
if command -v fzf &> /dev/null; then
    source /usr/share/fzf/key-bindings.zsh
    source /usr/share/fzf/completion.zsh
fi

# 3. Zoxide (Okos cd) - EZT PÓTOLTAM!
# A 'z mappa' parancs odaugrik a leggyakoribb helyre
if command -v zoxide &> /dev/null; then
    eval "$(zoxide init zsh)"
fi

# 4. Command-not-found hook
if [ -f /usr/share/doc/find-the-command/ftc.zsh ]; then
    source /usr/share/doc/find-the-command/ftc.zsh
fi

# 5. Oh My Posh indítása (Nordtron téma)
if command -v oh-my-posh &> /dev/null; then
    eval "$(oh-my-posh init zsh --config /usr/share/oh-my-posh/themes/nordtron.omp.json)"
fi

# =============================================================================
# ALIASOK
# =============================================================================

# --- Eza (modern ls) ---
alias ls="eza -al --color=always --group-directories-first --icons"
alias lsz="eza -al --color=always --total-size --group-directories-first --icons"
alias la="eza -a --color=always --group-directories-first --icons" 
alias ll="eza -l --color=always --group-directories-first --icons"
alias lt="eza -aT --color=always --group-directories-first --icons"
alias l.="eza -ald --color=always --group-directories-first --icons .*"

# --- Bat (modern cat) ---
alias cat="bat --style header --style snip --style changes --style header"

# --- Ugrep (modern grep) ---
alias grep="ugrep --color=auto"
alias egrep="ugrep -E --color=auto"
alias fgrep="ugrep -F --color=auto"

# --- Könyvtár navigáció ---
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ......="cd ../../../../.."

# --- Arch / Manjaro specifikus aliasok ---
alias upd="pamac update --no-confirm"
alias pacdiff="sudo -H DIFFPROG=meld pacdiff"
alias jctl="journalctl -p 3 -xb"
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
alias vdir="vdir --color=auto"
alias wget="wget -c"
alias rip="expac --timefmt='%Y-%m-%d %T' '%l\t%n %v' | sort | tail -200 | nl"

# --- Segítő aliasok ---
alias apt="man pacman"
alias apt-get="man pacman"
alias please="sudo"
alias tb="nc termbin.com 9999"
alias helpme="echo 'To print basic information about a command use helpme <command>'"

# =============================================================================
# FUNKCIÓK
# =============================================================================

# Biztonsági másolat készítése (.bak)
backup() {
    cp "$1" "$1.bak"
    echo "Backup created: $1.bak"
}

# Okos másolás (kezeli a mappák végi perjelet)
copy() {
    if [ $# -eq 2 ] && [ -d "$1" ]; then
        local from="${1%/}"
        local to="$2"
        command cp -r "$from" "$to"
    else
        command cp "$@"
    fi
}

# Árva csomagok takarítása (rekurzív)
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

# =============================================================================
# INTERAKTÍV ÉS TERMINÁL BEÁLLÍTÁSOK
# =============================================================================

# Tilix / VTE fix (Ctrl+Shift+T megtartja a könyvtárat)
if [ $TILIX_ID ] || [ $VTE_VERSION ]; then
    source /etc/profile.d/vte.sh
fi

# Fastfetch indítása (kivéve Quake módban)
if [[ -o interactive ]] && [[ -z "$QUAKE_MODE" ]] && command -v fastfetch > /dev/null 2>&1; then
    fastfetch --config neofetch.jsonc 2>/dev/null || fastfetch
fi
