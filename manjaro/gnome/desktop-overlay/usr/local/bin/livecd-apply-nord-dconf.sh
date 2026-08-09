#!/bin/bash
USER="manjaro"
HOME_DIR="/home/${USER}"
DUMP="/usr/share/livecd/nord-settings.dump"
RUNTIME_DIR="/run/user/1000"

# Ha a manjaro felhasználó nem létezik, azonnal lépjünk ki (pl. telepített rendszeren)
if ! id -u "$USER" >/dev/null 2>&1; then
    echo "User $USER does not exist. Exiting."
    exit 0
fi

# Várunk a home könyvtárra, de legfeljebb 10 másodpercig
TIMEOUT=10
SECONDS=0
while [ ! -d "$HOME_DIR" ] && [ $SECONDS -lt $TIMEOUT ]; do
    sleep 0.5
done

if [ ! -d "$HOME_DIR" ]; then
    echo "Home directory $HOME_DIR not available after ${TIMEOUT}s. Aborting."
    exit 1
fi

# Hozzuk létre a dconf könyvtárat, ha hiányzik
mkdir -p "$HOME_DIR/.config/dconf"
chown -R ${USER}:${USER} "$HOME_DIR/.config"

# Hozzuk létre a futásidejű könyvtárat (bár most már nincs rá szükség a kamu D‑Bus miatt, de biztonságból megtartjuk)
mkdir -p "$RUNTIME_DIR"
chown ${USER}:${USER} "$RUNTIME_DIR"
chmod 700 "$RUNTIME_DIR"

# Alkalmazzuk a dump fájlt kamu D‑Bus címmel, ami rákényszeríti a dconf-ot a közvetlen fájlírásra
sudo -u ${USER} env XDG_RUNTIME_DIR="$RUNTIME_DIR" DBUS_SESSION_BUS_ADDRESS=unix:path=/dev/null dconf load / < "$DUMP"
RET=$?

if [ $RET -eq 0 ]; then
    echo "Nord dconf settings applied for user ${USER}"
else
    echo "ERROR: dconf load failed with exit code $RET"
    exit 1
fi