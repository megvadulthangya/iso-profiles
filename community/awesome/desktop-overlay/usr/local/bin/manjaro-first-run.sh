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

# 2. UUID Detektálás (Kritikus a Timeshiftnek)
echo "--> Root partíció UUID keresése..."
ROOT_UUID=$(findmnt / -n -o UUID)

if [[ -z "$ROOT_UUID" ]]; then
    echo "❌ HIBA: Nem sikerült azonosítani a root UUID-t! A Timeshift beállítás megszakad."
    # Nem lépünk ki, hátha a többi sikerül, de ez kritikus hiba
else
    echo "✅ Root UUID azonosítva: $ROOT_UUID"
    
    echo "--> 3. Timeshift json generálása..."
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

# 4. Timeshift-autosnap konfiguráció (Az eredeti scriptből)
echo "--> 4. Timeshift-autosnap beállítása..."
cat > /etc/timeshift-autosnap.conf << 'EOF'
skipAutosnap=false
skipRsyncAutosnap=true
deleteSnapshots=true
maxSnapshots=10
updateGrub=true
snapshotDescription={timeshift-autosnap} {created before upgrade}
EOF
echo "✅ Timeshift-autosnap konfigurálva (Limit: 10)."

# 5. BTRFS Maintenance (Az eredeti scriptből)
echo "--> 5. BTRFS Maintenance beállítása..."
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

# 6. Mirrorok frissítése (TELJES LISTA ALAPJÁN)
echo "--> 6. Mirrorok frissítése (Ez eltarthat egy darabig)..."
if command -v pacman-mirrors &> /dev/null; then
    # -c all:        Minden létező országot engedélyez (reseteli a listát)
    # --protocols:   Csak HTTPS (biztonságos) tükröket keressen
    # --fasttrack 20: Megnézi a válaszidőket, és a TOP 20-at menti el
    pacman-mirrors --country all --api --protocols https --fasttrack 20 && pacman -Syy
    echo "✅ Mirrorok frissítve (Top 20 a teljes világlistából)."
else
    echo "⚠️ pacman-mirrors nem található."
fi

# 7. Szolgáltatások újraindítása az új konfigokkal
echo "--> 7. Szolgáltatások engedélyezése és újraindítása..."
systemctl daemon-reload

# BTRFS Maintenance szolgáltatások aktiválása
systemctl enable --now btrfs-scrub.timer
systemctl enable --now btrfs-trim.timer
systemctl enable --now btrfs-balance.timer

# udisks2
systemctl enable --now udisks2.service

echo "=========================================="
echo "✅ TELEPÍTÉS UTÁNI BEÁLLÍTÁSOK KÉSZEN!"
echo "=========================================="

# 8. ÖNGYILKOS MECHANIZMUS
# Letiltjuk a szolgáltatást, hogy többet ne fusson le
echo "--> Szolgáltatás letiltása a következő bootra..."
systemctl disable manjaro-first-run.service

exit 0
