#!/bin/bash
# /usr/local/bin/manjaro-first-run.sh

# Naplózás indítása
exec > >(tee -a /var/log/manjaro-first-run.log) 2>&1
echo "--> ELSŐ INDÍTÁS SZKRIPT KEZDÉSE: $(date)"

# --- 1. Timeshift beállítása (UUID detektálás) ---
ROOT_UUID=$(findmnt / -n -o UUID)
echo "--> Root UUID: $ROOT_UUID"

if [[ -n "$ROOT_UUID" ]]; then
    mkdir -p /etc/timeshift
    # JSON létrehozása a helyes UUID-val
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
    "/root/***", "/opt/***", "/var/***", "/srv/***", "/tmp/***",
    "/var/log/***", "/var/tmp/***", "/var/cache/***",
    "/home/*/.cache/***", "/home/*/.local/share/Trash/***"
  ],
  "exclude-apps" : []
}
EOF
    echo "--> Timeshift JSON létrehozva."
    
    # Timeshift inicializálása (subvolume structure)
    timeshift --check
else
    echo "HIBA: Nem sikerült az UUID-t lekérni."
fi

# --- 2. Mirrorok frissítése ---
# Csak akkor, ha van net, de megpróbáljuk
if command -v pacman-mirrors &> /dev/null; then
    echo "--> Mirrorok frissítése..."
    pacman-mirrors --fasttrack 5 && pacman -Syy
fi

# --- 3. Szolgáltatások biztosítása ---
systemctl enable --now btrfs-scrub.timer
systemctl enable --now btrfs-trim.timer
systemctl enable --now udisks2.service

echo "--> BEFEJEZVE."

# --- 4. ÖNGYILKOS MECHANIZMUS ---
# Ez a legfontosabb sor: letiltja a szolgáltatást, hogy többet soha ne fusson le.
systemctl disable manjaro-first-run.service
