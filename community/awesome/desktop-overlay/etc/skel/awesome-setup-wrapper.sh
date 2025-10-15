#!/bin/bash

# Nyelv érzékelése a rendszer nyelvi beállítása alapján
detect_language() {
    if [[ $LANG == *"hu"* ]] || [[ $LANGUAGE == *"hu"* ]]; then
        echo "hu"
    else
        echo "en"
    fi
}

# Üzenetek megjelenítése a nyelv alapján
show_message() {
    local lang=$(detect_language)
    
    if [ "$lang" = "hu" ]; then
        echo "==================================================================="
        echo "                   ⚠️  RENDSZERBEÁLLÍTÁSI FIGYELMEZTETÉS ⚠️"
        echo "==================================================================="
        echo ""
        echo "🚨 FONTOS: Ez a szkript kritikus rendszermódosításokat hajt végre!"
        echo "   Kérjük, olvassa el figyelmesen az alábbi információkat:"
        echo ""
        echo "🔴 ELŐFELTÉTELEK & FIGYELMEZTETÉSEK:"
        echo ""
        echo "📶  STABIL INTERNETKAPCSOLAT SZÜKSÉGES"
        echo "    • Megbízható internetkapcsolat szükséges a folyamat során"
        echo "    • Megszakítás telepítési hibákat okozhat"
        echo ""
        echo "⏰  BECSLT IDŐIGÉNY: 10 PERCTŐL 1 ÓRÁIG"
        echo "    • A folyamat csomagok fordítását és rendszerbeállításokat tartalmaz"
        echo "    • Az időtartam a rendszer sebességétől és internetkapcsolattól függ"
        echo ""
        echo "⚙️  RENDSZERVERMÓDOSÍTÁSOK TÖRTÉNNEK:"
        echo "    • Az alapértelmezett szerkesztő beállításai módosulnak"
        echo "    • Új betűtípusok települnek"
        echo "    • Szintaxis kiemelés kerül hozzáadásra"
        echo "    • Alapértelmezett témák változnak"
        echo "    • Különböző rendszerbeállítások módosulnak"
        echo ""
        echo "🔑 JELSZÓ TÖBBSZÖRI MEGADÁSA SZÜKSÉGES"
        echo "    • Többször is felkérjük a sudo jelszava megadására"
        echo "    • Ez normális a rendszerszintű telepítések során"
        echo "    • Legyen kéznél a jelszava!"
        echo ""
        echo "-------------------------------------------------------------------"
        echo ""
        echo "🎯 AZ AWESOME WM TELEPÍTÉSÉHEZ:"
        echo ""
        echo "   Futtassa a következő parancsot a terminálban:"
        echo "   ---------------------------------------------"
        echo "   🔥 sudo bash awesome-install 🔥"
        echo "   ---------------------------------------------"
        echo ""
        echo "❗ Ez a terminál nyitva marad a parancs végrehajtásához."
        echo "❗ Nyomjon meg egy billentyűt a terminál bezárásához, ha kész..."
        echo ""
        echo "==================================================================="
    else
        echo "==================================================================="
        echo "                   ⚠️  SYSTEM CONFIGURATION WARNING ⚠️"
        echo "==================================================================="
        echo ""
        echo "🚨 IMPORTANT: This script will perform CRITICAL system modifications!"
        echo "   Please read ALL of the following information carefully:"
        echo ""
        echo "🔴 PREREQUISITES & WARNINGS:"
        echo ""
        echo "📶  STABLE INTERNET CONNECTION REQUIRED"
        echo "    • A reliable internet connection is essential throughout the process"
        echo "    • Interruption may cause installation failures"
        echo ""
        echo "⏰  TIME REQUIREMENT: 10 MINUTES TO 1 HOUR"
        echo "    • Process involves compiling packages and system configuration"
        echo "    • Duration depends on your system speed and internet connection"
        echo ""
        echo "⚙️  SYSTEM CHANGES WILL BE MADE:"
        echo "    • Default editor settings will be modified"
        echo "    • New fonts will be installed"
        echo "    • Syntax highlighting will be added"
        echo "    • Default themes will be changed"
        echo "    • Various system configurations will be adjusted"
        echo ""
        echo "🔑 PASSWORD REQUIRED MULTIPLE TIMES"
        echo "    • You will be prompted for your sudo password SEVERAL times"
        echo "    • This is normal for system-level installations"
        echo "    • Have your password ready!"
        echo ""
        echo "-------------------------------------------------------------------"
        echo ""
        echo "🎯 TO PROCEED WITH AWESOME WM INSTALLATION:"
        echo ""
        echo "   Run this command in the terminal:"
        echo "   ---------------------------------"
        echo "   🔥 sudo bash awesome-install 🔥"
        echo "   ---------------------------------"
        echo ""
        echo "❗ This terminal will remain open for you to execute the command."
        echo "❗ Press any key to close this terminal when finished..."
        echo ""
        echo "==================================================================="
    fi
}

# Fő program
show_message
read -n 1 -s
