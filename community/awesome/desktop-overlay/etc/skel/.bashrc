#
# ~/.bashrc - Modernizált Manjaro Bash Konfiguráció
#

# Ha nem interaktív módban futunk, ne csináljunk semmit (fontos!)
[[ $- != *i* ]] && return

# =============================================================================
# KÖRNYEZETI VÁLTOZÓK
# =============================================================================

# PATH beállítások (Saját binárisok és depot_tools)
export PATH="$HOME/.local/bin:$HOME/Applications/depot_tools:$PATH"

# Alapértelmezett szerkesztő
export EDITOR=nano
export VISUAL=nano

# Manpager: bat használata man oldalak színezéséhez
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
export MANROFFOPT="-c"

# Qt téma beállítás (Awesome WM / Qtile kompatibilitás)
if command -v qtile > /dev/null 2>&1; then
    export QT_QPA_PLATFORMTHEME="qt5ct"
fi

# =============================================================================
# HISTORY BEÁLLÍTÁSOK (Hogy a Bash végre emlékezzen rendesen)
# =============================================================================

# Ne mentse a duplikációkat és a szóközzel kezdődő parancsokat
HISTCONTROL=ignoreboth:erasedups
# Nagyobb előzménytár
HISTSIZE=10000
HISTFILESIZE=20000
# Azonnali hozzáfűzés a fájlhoz (nem csak kilépéskor)
shopt -s histappend
# Ablakméret változás figyelése
shopt -s checkwinsize

# =============================================================================
# MODERN ESZKÖZÖK INTEGRÁCIÓJA (Zoxide, FZF, Prompt)
# =============================================================================

# 1. FZF (Fuzzy Finder) - A Ctrl+R keresés "javítása"
# Bash alatt ezeket a fájlokat kell betölteni:
if [ -f /usr/share/fzf/key-bindings.bash ]; then
    source /usr/share/fzf/key-bindings.bash
fi
if [ -f /usr/share/fzf/completion.bash ]; then
    source /usr/share/fzf/completion.bash
fi

# 2. Zoxide (Az a bizonyos "z betűs" okos cd)
if command -v zoxide &> /dev/null; then
    eval "$(zoxide init bash)"
fi

# 3. Oh My Posh (Prompt) - Nordtron téma, hogy egységes legyen a Zsh-val
if command -v oh-my-posh &> /dev/null; then
    eval "$(oh-my-posh init bash --config /usr/share/oh-my-posh/themes/nordtron.omp.json)"
else
    # Ha valamiért nincs Oh My Posh, legyen egy alap színes prompt
    PS1='\[\033[01;32m\][\u@\h\[\033[00m\] \w\[\033[01;32m\]]\$\[\033[00m\] '
fi

# 4. Command-not-found hook (Hogy szóljon, mit telepíts, ha nincs parancs)
if [ -f /usr/share/doc/pkgfile/command-not-found.bash ]; then
    source /usr/share/doc/pkgfile/command-not-found.bash
elif [ -f /usr/share/doc/find-the-command/ftc.bash ]; then
    source /usr/share/doc/find-the-command/ftc.bash
fi

# =============================================================================
# ALIASOK (Ugyanazok, mint Zsh/Fish alatt)
# =============================================================================

# --- Eza (ls helyett) ---
alias ls="eza -al --color=always --group-directories-first --icons"
alias lsz="eza -al --color=always --total-size --group-directories-first --icons"
alias la="eza -a --color=always --group-directories-first --icons"
alias ll="eza -l --color=always --group-directories-first --icons"
alias lt="eza -aT --color=always --group-directories-first --icons"
alias l.="eza -ald --color=always --group-directories-first --icons .*"

# --- Egyéb modern cserék ---
alias cat="bat --style header --style snip --style changes --style header"
alias grep="ugrep --color=auto"
alias egrep="ugrep -E --color=auto"
alias fgrep="ugrep -F --color=auto"

# --- Navigáció ---
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."

# --- Rendszerkarbantartás (Arch/Manjaro) ---
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
alias wget="wget -c"
alias rip="expac --timefmt='%Y-%m-%d %T' '%l\t%n %v' | sort | tail -200 | nl"
alias please="sudo"

# =============================================================================
# FUNKCIÓK
# =============================================================================

# Biztonsági másolat (.bak)
backup() {
    cp "$1" "$1.bak"
    echo "Backup created: $1.bak"
}

# Okos másolás
copy() {
    if [ $# -eq 2 ] && [ -d "$1" ]; then
        local from="${1%/}"
        local to="$2"
        command cp -r "$from" "$to"
    else
        command cp "$@"
    fi
}

# Árva csomagok takarítása
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
# EGYÉB ÉS INDÍTÁS
# =============================================================================

# Bash completion betöltése (fontos a Tab kiegészítéshez)
[ -r /usr/share/bash-completion/bash_completion ] && . /usr/share/bash-completion/bash_completion

# Fastfetch (rendszerinfó) indításkor
if [[ $- == *i* ]] && command -v fastfetch > /dev/null 2>&1; then
    fastfetch --config neofetch.jsonc 2>/dev/null || fastfetch
fi

# VTE / Tilix integráció (hogy a Ctrl+Shift+T megtartsa a mappát)
if [ $TILIX_ID ] || [ $VTE_VERSION ]; then
   if [ -f /etc/profile.d/vte.sh ]; then
        source /etc/profile.d/vte.sh
   fi
fi
