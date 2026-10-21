#!/bin/bash
# /usr/local/bin/manjaro-first-run.sh

# --- LOGOLÁS BEÁLLÍTÁSA (Így látni fogod a /var/log/manjaro-first-run.log fájlban) ---
LOG_FILE="/var/log/manjaro-first-run.log"
exec > >(tee -a "$LOG_FILE") 2>&1

echo "=========================================="
echo "   MANJARO FIRST RUN SETUP STARTING...    "
echo "   Dátum: $(date)"
echo "=========================================="

# 1. Root jogosultság ellenőrzése (bár service-ként ez alap)
if [[ $EUID -ne 0 ]]; then
   echo "❌ HIBA: Nem rootként fut!"
   exit 1
fi

# --- Háttérkép fallback felülírása (most az első lépés) ---
echo "--> Háttérkép fallback beállítása..."
TARGET_IMG="/usr/share/backgrounds/nordic-backgrounds/ign_manjaro.jpg"
FALLBACK_LINK="/usr/share/backgrounds/xfce/xfce-x.svg"

if [[ -f "$TARGET_IMG" ]]; then
    ln -sf "$TARGET_IMG" "$FALLBACK_LINK"
    echo "✅ Fallback háttérkép beállítva: $FALLBACK_LINK -> $TARGET_IMG"
else
    echo "⚠️ A cél háttérkép nem található: $TARGET_IMG - a fallback nem lett módosítva."
fi

# 2. UUID Detektálás (Kritikus a Timeshiftnek)
echo "--> Root partíció UUID keresése..."
ROOT_UUID=$(findmnt / -n -o UUID)

if [[ -z "$ROOT_UUID" ]]; then
    echo "❌ HIBA: Nem sikerült azonosítani a root UUID-t! A Timeshift beállítás megszakad."
    # Nem lépünk ki, hátha a többi sikerül, de ez kritikus hiba
else
    echo "✅ Root UUID azonosítva: $ROOT_UUID"
    
    echo "--> Timeshift json generálása..."
    mkdir -p /etc/timeshift
    
    # Itt az EREDETI konfigurációdat használjuk, de beillesztjük a $ROOT_UUID-t!
    cat > /etc/timeshift/timeshift.json << EOF
{
  "backup_device_uuid" : "$ROOT_UUID",
  "parent_device_uuid" : "",
  "do_first_run" : "false",
  "btrfs_mode" : "true",
  "include_btrfs_home_for_backup" : "true",
  "include_btrfs_home_for_restore" : "false",
  "stop_cron_emails" : "true",
  "schedule_monthly" : "false",
  "schedule_weekly" : "false",
  "schedule_daily" : "false",
  "schedule_hourly" : "false",
  "schedule_boot" : "false",
  "count_monthly" : "0",
  "count_weekly" : "0",
  "count_daily" : "0",
  "count_hourly" : "0",
  "count_boot" : "0",
  "snapshot_size" : "0",
  "snapshot_count" : "0",
  "date_format" : "%Y-%m-%d %H:%M:%S",
  "exclude" : [
    "/root/***",
    "/opt/***",
    "/var/***",
    "/srv/***",
    "/tmp/***",
    "/var/log/***",
    "/var/tmp/***",
    "/var/cache/***",
    "/home/*/.cache/***",
    "/home/*/.local/share/Trash/***"
  ],
  "exclude-apps" : []
}
EOF
    echo "✅ Timeshift JSON létrehozva."
    
    # Timeshift inicializálás
    echo "--> Timeshift subvolume check..."
    timeshift --check
fi

# Timeshift-autosnap konfiguráció
echo "--> Timeshift-autosnap beállítása..."
cat > /etc/timeshift-autosnap.conf << 'EOF'
skipAutosnap=false
skipRsyncAutosnap=true
deleteSnapshots=true
maxSnapshots=10
updateGrub=true
snapshotDescription={timeshift-autosnap} {created before upgrade}
minHoursBetweenSnapshots=0
EOF
echo "✅ Timeshift-autosnap konfigurálva (Limit: 10)."

# BTRFS Maintenance
echo "--> BTRFS Maintenance beállítása..."
cat > /etc/default/btrfsmaintenance << 'EOF'
BTRFS_LOG_OUTPUT="stdout"
BTRFS_DEFRAG_PATHS="auto"
BTRFS_DEFRAG_PERIOD="weekly"
BTRFS_DEFRAG_MIN_SIZE="+1M"
BTRFS_BALANCE_MOUNTPOINTS="auto"
BTRFS_BALANCE_PERIOD="monthly"
BTRFS_BALANCE_DUSAGE="5 10"
BTRFS_BALANCE_MUSAGE="5"
BTRFS_SCRUB_MOUNTPOINTS="auto"
BTRFS_SCRUB_PERIOD="weekly"
BTRFS_SCRUB_PRIORITY="idle"
BTRFS_SCRUB_READ_ONLY="false"
BTRFS_TRIM_PERIOD="weekly"
BTRFS_TRIM_MOUNTPOINTS="auto"
BTRFS_ALLOW_CONCURRENCY="false"
EOF
echo "✅ BTRFS Maintenance konfigurálva."

# Szolgáltatások újraindítása az új konfigokkal
echo "--> Szolgáltatások engedélyezése és újraindítása..."
systemctl daemon-reload

# BTRFS Maintenance szolgáltatások aktiválása
systemctl enable --now btrfs-scrub.timer
systemctl enable --now btrfs-trim.timer
systemctl enable --now btrfs-balance.timer

# udisks2
systemctl enable --now udisks2.service

# Repo kulcsok hozzáadása (arch, manjaro, manjaro-awesome) - jelenleg kikapcsolva
#echo "--> Repo kulcsok hozzáadása (arch, manjaro, manjaro-awesome)..."
#KEYS=(
#    "B97F7C613F359424" # arch
#    "D1445F51BC0A8969" # manjaro
#    "A9A569C8F797B6878E44C4F8FBF4AB57E9BB9D3C" # manjaro-awesome
#)
#for KEYID in "${KEYS[@]}"; do
#    echo "--> Kulcs feldolgozása: ${KEYID}"
#    if pacman-key --list-keys "${KEYID}" &>/dev/null; then
#        echo "✅ Kulcs már létezik a keyringben: ${KEYID}"
#    else
#        echo "--> Letöltés keyserver.ubuntu.com-ról..."
#        pacman-key --keyserver keyserver.ubuntu.com --recv-keys "${KEYID}"
#        echo "✅ Kulcs importálva: ${KEYID}"
#    fi
#    pacman-key --lsign-key "${KEYID}"
#    echo "✅ Kulcs locally signed: ${KEYID}"
#done

# Mirrorok frissítése (KONTINENS ALAPJÁN)
echo "--> Mirrorok frissítése (Helyi kontinens szervereinek keresése)..."

if command -v pacman-mirrors &> /dev/null; then
    # --continent: Érzékeli a felhasználó kontinensét (pl. Európa vagy Észak-Amerika)
    #              Így kis országokban (mint HU) is lesz bőven tartalék szerver a szomszédoktól.
    # --api:       Frissíti a listát
    # --protocols: Csak HTTPS
    pacman-mirrors --continent --api --protocols https && pacman -Syy
    
    echo "✅ Mirrorok frissítve (Kontinens szintű lista a biztonság érdekében)."
else
    echo "⚠️ pacman-mirrors nem található."
fi

echo "=========================================="
echo "✅ TELEPÍTÉS UTÁNI BEÁLLÍTÁSOK KÉSZEN!"
echo "=========================================="

# ÖNGYILKOS MECHANIZMUS
# Letiltjuk a szolgáltatást, hogy többet ne fusson le
echo "--> Szolgáltatás letiltása a következő bootra..."
systemctl disable manjaro-first-run.service

exit 0