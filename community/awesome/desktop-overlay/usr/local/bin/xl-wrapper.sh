#!/bin/bash

# XLibre telepítő wrapper script
# Nyelv érzékelés és megfelelő üzenetek

# Lock fájl a többszörös futtatás megelőzésére
LOCKFILE="/tmp/xlibre-installer.lock"

# Lock ellenőrzés
if [ -f "$LOCKFILE" ]; then
    if [[ $LANG == hu* ]]; then
        echo "Az XLibre telepítő már fut!"
    else
        echo "XLibre installer is already running!"
    fi
    exit 1
fi

# Lock fájl létrehozása
touch "$LOCKFILE"

# Lock fájl törlése kilépéskor
trap 'rm -f "$LOCKFILE"' EXIT INT TERM

# Nyelv beállítása a rendszer locale alapján
if [[ $LANG == hu* ]]; then
    # Magyar nyelvű üzenetek
    INSTALLED_MSG="Az XLibre már telepítve van!"
    INSTALLING_MSG="XLibre telepítése terminál ablakban..."
    DOWNLOAD_FAIL_MSG="A telepítő letöltése sikertelen!"
    NO_TERMINAL_MSG="Nem található terminál emulátor. Telepítsen egyet (pl. xfce4-terminal, tilix)!"
    TEST_MSG="XLibre telepítő elindul..."
    PRESS_ENTER="Nyomj Enter-t a bezáráshoz..."
    ALREADY_RUNNING_MSG="A telepítő már fut!"
else
    # Angol nyelvű üzenetek (alapértelmezett)
    INSTALLED_MSG="XLibre is already installed!"
    INSTALLING_MSG="Starting XLibre installation in terminal window..."
    DOWNLOAD_FAIL_MSG="Failed to download installer!"
    NO_TERMINAL_MSG="No terminal emulator found. Please install one (e.g. xfce4-terminal, tilix)!"
    TEST_MSG="XLibre installer starting..."
    PRESS_ENTER="Press Enter to close..."
    ALREADY_RUNNING_MSG="Installer is already running!"
fi

# Ellenőrizzük, hogy XLibre már telepítve van-e
check_installation() {
    if pacman -Q xlibre-xserver &>/dev/null 2>&1; then
        show_message "XLibre" "$INSTALLED_MSG"
        exit 0
    fi
}

# Terminál emulátor keresése - prioritás: tilix, majd xfce4-terminal, majd többi
find_terminal() {
    # Először keressük a tilix-et, mert ez a felhasználó későbbi preferenciája lehet
    if command -v tilix &>/dev/null; then
        echo "tilix"
        return 0
    fi
    
    # Majd az xfce4-terminal, ami alapból van a rendszerben
    if command -v xfce4-terminal &>/dev/null; then
        echo "xfce4-terminal"
        return 0
    fi
    
    # Végül más terminálok
    local terminals=("gnome-terminal" "konsole" "mate-terminal" "terminator" "xterm" "urxvt" "alacritty")
    
    for term in "${terminals[@]}"; do
        if command -v "$term" &>/dev/null; then
            echo "$term"
            return 0
        fi
    done
    return 1
}

# Üzenet megjelenítése (notify-send vagy echo)
show_message() {
    local title="$1"
    local message="$2"
    
    if command -v notify-send &>/dev/null; then
        notify-send "$title" "$message"
    else
        echo "$title: $message"
    fi
}

# Telepítő letöltése
download_installer() {
    local temp_script=$(mktemp)
    if ! curl -sS -o "$temp_script" "https://x11libre.net/repo/arch_based/x86_64/install-xlibre.sh"; then
        show_message "XLibre" "$DOWNLOAD_FAIL_MSG"
        exit 1
    fi
    chmod +x "$temp_script"
    echo "$temp_script"
}

# Fő telepítő funkció
install_xlibre() {
    # 1. Értesítés küldése
    show_message "XLibre" "$INSTALLING_MSG"
    
    # 2. Telepítő script letöltése
    local temp_script=$(download_installer)
    
    # 3. Terminál keresése és indítása
    local terminal=$(find_terminal)
    
    if [ -z "$terminal" ]; then
        show_message "XLibre" "$NO_TERMINAL_MSG"
        rm -f "$temp_script"
        exit 1
    fi

    # 4. Terminál indítása a telepítővel - külön kezeljük a tilix-et és xfce4-terminal-t
    case "$terminal" in
        "tilix")
            # Tilix speciális kezelése - ezt a felhasználó később telepítheti
            tilix -e bash -c "echo '$TEST_MSG'; echo ''; sudo '$temp_script'; echo ''; echo '$PRESS_ENTER'; read"
            ;;
        "xfce4-terminal")
            # xfce4-terminal - ez van alapból a rendszerben
            xfce4-terminal --hold --geometry=80x24 -e "bash -c 'echo \"$TEST_MSG\"; echo; sudo $temp_script; echo; echo \"$PRESS_ENTER\"; read'"
            ;;
        "gnome-terminal"|"mate-terminal")
            "$terminal" -- bash -c "echo '$TEST_MSG'; echo; sudo '$temp_script'; echo; echo '$PRESS_ENTER'; read"
            ;;
        "konsole")
            "$terminal" -e bash -c "echo '$TEST_MSG'; echo; sudo '$temp_script'; echo; echo '$PRESS_ENTER'; read"
            ;;
        *)
            # Egyéb terminálok (xterm, urxvt, stb.)
            "$terminal" -e bash -c "echo '$TEST_MSG'; echo; sudo '$temp_script'; echo; echo '$PRESS_ENTER'; read"
            ;;
    esac
    
    # 5. Temp fájl törlése (a terminál bezárása után)
    rm -f "$temp_script"
}

# Fő program
main() {
    # Telepítés ellenőrzése
    check_installation

    # Ha nem volt telepítve, indítjuk a telepítést
    install_xlibre
}

# Script indítása
main "$@"