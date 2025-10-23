#!/bin/bash

# Továbbfejlesztett nyelvérzékelés
detect_language() {
    # Először próbáljuk a systemd locale-t
    if command -v localectl &> /dev/null; then
        local system_lang=$(localectl status | grep "System Locale" | awk -F'=' '{print $2}')
        if [[ $system_lang == *"hu"* ]] || [[ $system_lang == *"HU"* ]]; then
            echo "hu"
            return
        fi
    fi

    # Majd a környezeti változókat
    if [[ $LANG == *"hu"* ]] || [[ $LANGUAGE == *"hu"* ]] || [[ $LC_ALL == *"hu"* ]]; then
        echo "hu"
    elif [[ $LANG == *"en"* ]] || [[ $LANGUAGE == *"en"* ]] || [[ $LC_ALL == *"en"* ]]; then
        echo "en"
    else
        # Alapértelmezett angol
        echo "en"
    fi
}

# Lapozható szöveg megjelenítése
show_paginated() {
    local text="$1"
    local lang="$2"
    local lines_per_page=10
    local current_line=0

    # Nyelvfüggő üzenet
    local continue_msg
    if [ "$lang" = "hu" ]; then
        continue_msg=">>> Nyomj Entert a folytatáshoz... "
    else
        continue_msg=">>> Press Enter to continue... "
    fi

    # Szöveg felosztása sorokra
    IFS=$'\n' read -d '' -ra lines <<< "$text"

    for line in "${lines[@]}"; do
        echo "$line"
        ((current_line++))

        # Lapozás minden X sor után, vagy üres soroknál
        if [[ $current_line -ge $lines_per_page ]] || [[ -z "$line" ]]; then
            if [[ -z "$line" ]] && [[ $current_line -ge $((lines_per_page/2)) ]]; then
                echo ""
                read -p "$continue_msg" < /dev/tty
                echo ""
                current_line=0
            elif [[ $current_line -ge $lines_per_page ]]; then
                echo ""
                read -p "$continue_msg" < /dev/tty
                echo ""
                current_line=0
            fi
        fi
    done
}

# Részletes magyarázat a telepítési folyamatról
show_detailed_explanation() {
    local lang=$(detect_language)

    if [ "$lang" = "hu" ]; then
        local explanation="📋 RÉSZLETES TELEPÍTÉSI FOLYAMAT:
==========================================

1. 🗂️  SNAPPER BEÁLLÍTÁS (BTRFS SNAPSHOTOK)
   • Automatikus rendszerpillanatképek beállítása
   • Térkorlát: 0.5% (fél százalék)
   • Heti/havi/éves snapshot takarítás
   • Teszt snapshot készítése

2. 🛠️  BTRFS KARBANTARTÁS IDŐZÍTŐK
   • Heti BTRFS scrub (adatintegritás ellenőrzés)
   • Havi BTRFS balance (adatkiegyenlítés)
   • Heti TRIM (szabad terület optimalizálás)
   • Garuda Linux-stílusú karbantartás

3. 📦 CSOMAGOK TELEPÍTÉSE (100+ CSOMAG)
   • Alap rendszereszközök: dmenu, rofi, flameshot, picom
   • Fejlesztőeszközök: geany, git, fzf, bat, eza
   • Hang/mediakezelés: mpd, mpc, playerctl, alsa-utils
   • Hálózat: network-manager-applet, wavemon
   • AUR csomagok: awesome-git, nordic témák, grayjay-bin

4. 🎨 NORDIC TÉMA TELJES KÖRŰ BEÁLLÍTÁSA
   • GTK téma: Nordic-standard-buttons
   • Ikon téma: Nordzy-dark
   • Kurzor téma: Nordic-cursors
   • Betűtípus: FiraCode Nerd Font
   • Kvantum témák rendszerszintű telepítése
   • Rofi témák (Adi1090x stílus)
   • LightDM beállítás nordic háttérrel

5. ⚙️  RENDSZERBEÁLLÍTÁSOK
   • Nano alapértelmezett szerkesztővé tétele
   • Nano szintaxis kiemelés engedélyezése
   • Fish shell beállítása (root számára)
   • Automatikus lock (videólejátszás közben nem aktiválódik)
   • XFCE beállítások optimalizálása
   • Minden felhasználó számára konfigurálás (/etc/skel)

6. 🎪 AWESOMEWM KONFIGURÁCIÓ
   • AwesomeWM Copycats konfiguráció telepítése
   • Automatikus symlinkek létrehozása
   • Nordikus háttérképek telepítése
   • Mission Impossibru szkriptek aktiválása

7. 🧹 TAKARÍTÁS ÉS ÖNMEGSEMMISÍTÉS
   • Régi telepítési fájlok eltávolítása
   • Átmeneti fájlok törlése
   • Telepítő szkript önmegsemmisítése

⏰ BECSÜLT IDŐ: 15-60 perc (processzor és internet sebességtől függ)"
    else
        local explanation="📋 DETAILED INSTALLATION PROCESS:
==========================================

1. 🗂️  SNAPPER SETUP (BTRFS SNAPSHOTS)
   • Automatic system snapshot configuration
   • Space limit: 0.5% (half percent)
   • Weekly/monthly/yearly snapshot cleanup
   • Test snapshot creation

2. 🛠️  BTRFS MAINTENANCE TIMERS
   • Weekly BTRFS scrub (data integrity check)
   • Monthly BTRFS balance (data rebalancing)
   • Weekly TRIM (free space optimization)
   • Garuda Linux-style maintenance

3. 📦 PACKAGE INSTALLATION (100+ PACKAGES)
   • System tools: dmenu, rofi, flameshot, picom
   • Developer tools: geany, git, fzf, bat, eza
   • Audio/media: mpd, mpc, playerctl, alsa-utils
   • Network: network-manager-applet, wavemon
   • AUR packages: awesome-git, nordic themes, grayjay-bin

4. 🎨 COMPLETE NORDIC THEME SETUP
   • GTK theme: Nordic-standard-buttons
   • Icon theme: Nordzy-dark
   • Cursor theme: Nordic-cursors
   • Font: FiraCode Nerd Font
   • System-wide Kvantum themes
   • Rofi themes (Adi1090x style)
   • LightDM setup with nordic background

5. ⚙️  SYSTEM CONFIGURATIONS
   • Set Nano as default editor
   • Enable Nano syntax highlighting
   • Configure Fish shell (for root)
   • Automatic lock (disabled during video playback)
   • Optimize XFCE settings
   • Configure for all users (/etc/skel)

6. 🎪 AWESOMEWM CONFIGURATION
   • Install AwesomeWM Copycats configuration
   • Create automatic symlinks
   • Install Nordic wallpapers
   • Activate Mission Impossibru scripts

7. 🧹 CLEANUP AND SELF-DESTRUCT
   • Remove old installation files
   • Clean temporary files
   • Self-destruct installer script

⏰ ESTIMATED TIME: 15-60 minutes (depends on CPU and internet speed)"
    fi

    show_paginated "$explanation" "$lang"
}

# Fő üzenet megjelenítése
show_message() {
    local lang=$(detect_language)

    if [ "$lang" = "hu" ]; then
        local header="===================================================================
                   ⚠️  RENDSZERBEÁLLÍTÁSI FIGYELMEZTETÉS ⚠️
===================================================================

🚨 FONTOS: Ez a szkript kritikus rendszermódosításokat hajt végre!
   Kérjük, olvassa el figyelmesen az alábbi információkat:"

        local prerequisites="🔴 ELŐFELTÉTELEK & FIGYELMEZTETÉSEK:

📶  STABIL INTERNETKAPCSOLAT SZÜKSÉGES
    • Megbízható internetkapcsolat szükséges a folyamat során
    • Megszakítás telepítési hibákat okozhat
    • Több száz MB adatletöltés várható

⏰  BECSLT IDŐIGÉNY: 15 PERCTŐL 60 PERCIG
    • A folyamat csomagok fordítását és rendszerbeállításokat tartalmaz
    • Az időtartam a rendszer sebességétől és internetkapcsolattól függ
    • A folyamat több szakaszban fut, részletes leírást lásd alább"

        local changes="⚙️  RENDSZERVERMÓDOSÍTÁSOK TÖRTÉNNEK:
    • Snapper (BTRFS snapshot) konfiguráció készül
    • BTRFS karbantartó időzítők aktiválódnak
    • Több 100 csomag települ (GTK, QT, AwesomeWM, stb.)
    • Nordic téma kerül telepítésre mindenhol
    • Az alapértelmezett szerkesztő beállításai módosulnak
    • Új betűtípusok települnek
    • Szintaxis kiemelés kerül hozzáadásra
    • Alapértelmezett témák változnak
    • Különböző rendszerbeállítások módosulnak
    • LightDM beállítások változnak
    • Fish shell lesz az alapértelmezett (root számára)"

        local password="🔑 JELSZÓ TÖBBSZÖRI MEGADÁSA SZÜKSÉGES
    • Többször is felkérjük a sudo jelszava megadására
    • Ez normális a rendszerszintű telepítések során
    • Legyen kéznél a jelszava!"

        local footer="-------------------------------------------------------------------

🎯 AZ AWESOME WM TELEPÍTÉSÉHEZ:

   Futtassa a következő parancsot a terminálban:
   ---------------------------------------------
   🔥 sudo bash awesome-install 🔥
   ---------------------------------------------

❗ Ez a terminál nyitva marad a parancs végrehajtásához.
❗ Nyomjon meg egy billentyűt a terminál bezárásához, ha kész...

==================================================================="

        # Lapozható megjelenítés
        show_paginated "$header" "$lang"
        echo ""
        show_paginated "$prerequisites" "$lang"
        echo ""
        show_paginated "$changes" "$lang"
        echo ""
        show_paginated "$password" "$lang"
        echo ""

        # Részletes folyamat megjelenítése
        show_detailed_explanation

        show_paginated "$footer" "$lang"

    else
        local header="===================================================================
                   ⚠️  SYSTEM CONFIGURATION WARNING ⚠️
===================================================================

🚨 IMPORTANT: This script will perform CRITICAL system modifications!
   Please read ALL of the following information carefully:"

        local prerequisites="🔴 PREREQUISITES & WARNINGS:

📶  STABLE INTERNET CONNECTION REQUIRED
    • A reliable internet connection is essential throughout the process
    • Interruption may cause installation failures
    • Several hundred MB of data will be downloaded

⏰  TIME REQUIREMENT: 15 MINUTES TO 60 MINUTES
    • Process involves compiling packages and system configuration
    • Duration depends on your system speed and internet connection
    • Process runs in multiple phases, see detailed description below"

        local changes="⚙️  SYSTEM CHANGES WILL BE MADE:
    • Snapper (BTRFS snapshot) configuration will be set up
    • BTRFS maintenance timers will be activated
    • Hundreds of packages will be installed (GTK, QT, AwesomeWM, etc.)
    • Nordic theme will be installed system-wide
    • Default editor settings will be modified
    • New fonts will be installed
    • Syntax highlighting will be added
    • Default themes will be changed
    • Various system configurations will be adjusted
    • LightDM settings will be changed
    • Fish shell will be set as default (for root)"

        local password="🔑 PASSWORD REQUIRED MULTIPLE TIMES
    • You will be prompted for your sudo password SEVERAL times
    • This is normal for system-level installations
    • Have your password ready!"

        local footer="-------------------------------------------------------------------

🎯 TO PROCEED WITH AWESOME WM INSTALLATION:

   Run this command in the terminal:
   ---------------------------------
   🔥 sudo bash awesome-install 🔥
   ---------------------------------

❗ This terminal will remain open for you to execute the command.
❗ Press any key to close this terminal when finished...

==================================================================="

        # Paginated display in English
        show_paginated "$header" "$lang"
        echo ""
        show_paginated "$prerequisites" "$lang"
        echo ""
        show_paginated "$changes" "$lang"
        echo ""
        show_paginated "$password" "$lang"
        echo ""

        # Detailed process in English
        show_detailed_explanation

        show_paginated "$footer" "$lang"
    fi
}

# Fő program
show_message
read -n 1 -s
