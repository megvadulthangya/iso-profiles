#!/bin/bash
# Várja meg, amíg a manjaro felhasználó home-ja elérhető
USER="manjaro"
HOME_DIR="/home/${USER}"
DUMP="/usr/share/livecd/nord-settings.dump"

while [ ! -d "$HOME_DIR" ]; do
    sleep 0.5
done

# Hozza létre a .config/dconf könyvtárat, ha hiányzik
mkdir -p "$HOME_DIR/.config/dconf"
chown ${USER}:${USER} "$HOME_DIR/.config/dconf"

# Betölti a dump fájlt a manjaro felhasználó dconf adatbázisába
# A "dconf load" direktben írja a bináris user fájlt, nincs szükség D-Bus sessionre,
# ha a HOME megfelelően be van állítva és az eszköz nem tud kapcsolódni a buszhoz.
sudo -u ${USER} -- dconf load / < "$DUMP"

echo "Nord dconf settings applied for user ${USER}"