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

# ==============================
# CachyOS repo setup (FIRST-RUN, repo+key only, NO package operations)
# SAFE VERSION: keeps existing generic [cachyos] repo, only replaces CPU-specific repos
# ==============================
setup_cachyos_repos_first_run() {
  local CACHYOS_KEYID="F3B607488DB35A47"
  local PACMAN_CONF="/etc/pacman.conf"
  local PACMAN_CONF_BAK="/etc/pacman.conf.bak.cachyos-first-run.$(date +%Y%m%d%H%M%S)"

  echo "=== CACHYOS FIRST-RUN REPO SETUP START ==="

  if [[ $EUID -ne 0 ]]; then
    echo "❌ CACHYOS: root jogosultság kell."
    return 1
  fi

  if [[ ! -f "$PACMAN_CONF" ]]; then
    echo "❌ CACHYOS: $PACMAN_CONF nem található."
    return 1
  fi

  # --- 1) Keyring init (ha kell) ---
  if [[ ! -d /etc/pacman.d/gnupg ]] || [[ ! -f /etc/pacman.d/gnupg/pubring.kbx ]]; then
    echo "CACHYOS: pacman-key init (missing keyring)"
    pacman-key --init
    pacman-key --populate archlinux
  fi

  # Legyen local secret key is lsign-hoz
  if ! pacman-key --list-secret-keys >/dev/null 2>&1 || [[ -z "$(pacman-key --list-secret-keys 2>/dev/null)" ]]; then
    echo "CACHYOS: pacman-key init (no local secret key for lsign)"
    pacman-key --init
    pacman-key --populate archlinux
  fi

  # --- 2) CachyOS key import + local sign (idempotens) ---
  echo "CACHYOS: importing key ${CACHYOS_KEYID} from keyserver.ubuntu.com"

  local key_ok=0
  local attempt
  for attempt in 1 2; do
    echo "CACHYOS: recv-keys attempt=${attempt} (keyserver.ubuntu.com)"
    if pacman-key --keyserver keyserver.ubuntu.com --recv-keys "${CACHYOS_KEYID}"; then
      key_ok=1
      break
    fi
    sleep 2
  done

  # opcionális fallback HKPS-re
  if [[ "$key_ok" -ne 1 ]]; then
    for attempt in 1 2; do
      echo "CACHYOS: recv-keys attempt=${attempt} (hkps://keyserver.ubuntu.com)"
      if pacman-key --keyserver hkps://keyserver.ubuntu.com --recv-keys "${CACHYOS_KEYID}"; then
        key_ok=1
        break
      fi
      sleep 2
    done
  fi

  if [[ "$key_ok" -ne 1 ]]; then
    echo "❌ CACHYOS: a kulcs importálása sikertelen."
    return 1
  fi

  echo "CACHYOS: local-sign key"
  pacman-key --lsign-key "${CACHYOS_KEYID}"

  # --- 3) CPU tier detektálás a célgépen ---
  # Sorrend:
  #   znver4/5 -> znver4
  #   x86-64-v4 -> v4
  #   x86-64-v3 -> v3
  #   különben -> generic
  local tier="generic"
  local arch_dir=""
  local repo_a=""
  local repo_b=""
  local repo_c=""

  if command -v gcc >/dev/null 2>&1; then
    local march
    march="$(gcc -march=native -Q --help=target 2>/dev/null | awk '/^[[:space:]]+-march=/{print $2; exit}' || true)"
    if [[ "${march:-}" == "znver4" || "${march:-}" == "znver5" ]]; then
      tier="znver4"
    fi
  fi

  if [[ "$tier" != "znver4" ]]; then
    if /lib/ld-linux-x86-64.so.2 --help 2>/dev/null | grep -q "x86-64-v4 (supported"; then
      tier="v4"
    elif /lib/ld-linux-x86-64.so.2 --help 2>/dev/null | grep -q "x86-64-v3 (supported"; then
      tier="v3"
    else
      tier="generic"
    fi
  fi

  case "$tier" in
    v3)
      arch_dir="x86_64_v3"
      repo_a="cachyos-v3"
      repo_b="cachyos-core-v3"
      repo_c="cachyos-extra-v3"
      ;;
    v4)
      arch_dir="x86_64_v4"
      repo_a="cachyos-v4"
      repo_b="cachyos-core-v4"
      repo_c="cachyos-extra-v4"
      ;;
    znver4)
      arch_dir="x86_64_v4"
      repo_a="cachyos-znver4"
      repo_b="cachyos-core-znver4"
      repo_c="cachyos-extra-znver4"
      ;;
    *)
      tier="generic"
      ;;
  esac

  echo "CACHYOS: detected tier=${tier}"

  # --- 4) Backup ---
  cp -a "$PACMAN_CONF" "$PACMAN_CONF_BAK"
  echo "CACHYOS: backup created -> $PACMAN_CONF_BAK"

  # --- 5) Csak a CPU-specifikus CachyOS repo szekciók eltávolítása (generic [cachyos] MEGMARAD) ---
  local tmp_conf
  tmp_conf="$(mktemp)"

  awk '
    BEGIN { skip=0 }
    /^\[(cachyos-v3|cachyos-core-v3|cachyos-extra-v3|cachyos-v4|cachyos-core-v4|cachyos-extra-v4|cachyos-znver4|cachyos-core-znver4|cachyos-extra-znver4)\][[:space:]]*$/ {
      skip=1
      next
    }
    skip && /^\[/ {
      skip=0
      print
      next
    }
    skip { next }
    { print }
  ' "$PACMAN_CONF" > "$tmp_conf"

  mv "$tmp_conf" "$PACMAN_CONF"
  # Javítás: megfelelő jogosultság beállítása, hogy ne root-only legyen
  chmod 644 "$PACMAN_CONF"

  # --- 6) CPU-specifikus blokk összeállítása (ha nem generic) ---
  local tier_block_file=""
  if [[ "$tier" != "generic" ]]; then
    tier_block_file="$(mktemp)"
    cat > "$tier_block_file" <<EOF

# ==============================
# CachyOS CPU-specific repos (managed by first-run script)
# Auto-selected tier: $tier
# ==============================

[$repo_a]
SigLevel = PackageRequired
Server = https://mirror.cachyos.org/repo/$arch_dir/$repo_a/

[$repo_b]
SigLevel = PackageRequired
Server = https://mirror.cachyos.org/repo/$arch_dir/$repo_b/

[$repo_c]
SigLevel = PackageRequired
Server = https://mirror.cachyos.org/repo/$arch_dir/$repo_c/

EOF
  fi

  # --- 7) [cachyos] generic repo jelenlétének ellenőrzése ---
  local has_generic=0
  if grep -qE '^\[cachyos\][[:space:]]*$' "$PACMAN_CONF"; then
    has_generic=1
  fi

  # --- 8) CPU-specifikus blokk beszúrása a [cachyos] elé (ha van generic) ---
  if [[ "$tier" != "generic" ]]; then
    if [[ "$has_generic" -eq 1 ]]; then
      local tmp_insert
      tmp_insert="$(mktemp)"

      awk -v insert_file="$tier_block_file" '
        BEGIN { inserted=0 }
        /^\[cachyos\][[:space:]]*$/ && !inserted {
          while ((getline line < insert_file) > 0) print line
          close(insert_file)
          inserted=1
          print
          next
        }
        { print }
      ' "$PACMAN_CONF" > "$tmp_insert"

      mv "$tmp_insert" "$PACMAN_CONF"
      # Javítás: ismét megfelelő jogosultság
      chmod 644 "$PACMAN_CONF"
      echo "CACHYOS: inserted CPU-specific repos before existing [cachyos]"
    else
      # nincs generic repo -> appendeljük a CPU-specifikus blokkot + generic blokkot
      cat "$tier_block_file" >> "$PACMAN_CONF"
      cat >> "$PACMAN_CONF" <<'EOF'

# ==============================
# CachyOS generic repo (managed by first-run script)
# ==============================

[cachyos]
SigLevel = PackageRequired
Server = https://mirror.cachyos.org/repo/x86_64/cachyos/

EOF
      # Itt nem használtunk mv-t, de a jogosultság lehet, hogy helyes, de biztos, ami biztos:
      chmod 644 "$PACMAN_CONF"
      echo "CACHYOS: generic [cachyos] was missing -> added"
    fi
  else
    # generic tier: nem kell CPU-specifikus repo
    # csak biztosítjuk, hogy [cachyos] meglegyen
    if [[ "$has_generic" -ne 1 ]]; then
      cat >> "$PACMAN_CONF" <<'EOF'

# ==============================
# CachyOS generic repo (managed by first-run script)
# ==============================

[cachyos]
SigLevel = PackageRequired
Server = https://mirror.cachyos.org/repo/x86_64/cachyos/

EOF
      chmod 644 "$PACMAN_CONF"
      echo "CACHYOS: generic [cachyos] was missing -> added"
    else
      echo "CACHYOS: existing generic [cachyos] kept as-is"
    fi
  fi

  # takarítás
  if [[ -n "${tier_block_file:-}" && -f "${tier_block_file:-}" ]]; then
    rm -f "$tier_block_file"
  fi

  echo "CACHYOS: pacman.conf updated successfully (tier=${tier})"
  echo "=== CACHYOS FIRST-RUN REPO SETUP END ==="

  # SZÁNDÉKOSAN nincs itt pacman -Sy / -Syu / pacman -U
  return 0
}

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
minHoursBetweenSnapshots=0
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


# 6. Szolgáltatások újraindítása az új konfigokkal
echo "--> 6. Szolgáltatások engedélyezése és újraindítása..."
systemctl daemon-reload

# BTRFS Maintenance szolgáltatások aktiválása
systemctl enable --now btrfs-scrub.timer
systemctl enable --now btrfs-trim.timer
systemctl enable --now btrfs-balance.timer

# udisks2
systemctl enable --now udisks2.service


# 7 Repo kulcs hozzáadása (manjaro-awesome) - hogy a pacman -Syy ne akadjon el
echo "--> 7 Manjaro-awesome repo kulcs hozzáadása..."

KEYID="A9A569C8F797B6878E44C4F8FBF4AB57E9BB9D3C"
REPO_PUB_URL="https://repo.gshoots.hu/manjaro-awesome/x86_64/manjaro-awesome.pub"
KOO_URL="https://keys.openpgp.org/vks/v1/by-fingerprint/${KEYID}"

# Ha már megvan, nem csinálunk semmit
if pacman-key --list-keys "${KEYID}" &>/dev/null; then
    echo "✅ Kulcs már létezik a keyringben: ${KEYID}"
else
    echo "--> Kulcs letöltése és importálása..."

    TMPKEY="$(mktemp)"

    # 1) Első körben a saját repo publikus kulcs (stabilabb)
    if command -v curl &>/dev/null; then
        curl -fsSL "${REPO_PUB_URL}" -o "${TMPKEY}" || true
    else
        wget -qO "${TMPKEY}" "${REPO_PUB_URL}" || true
    fi

    # Ha üres/hibás lett, fallback keys.openpgp.org
    if [ ! -s "${TMPKEY}" ]; then
        echo "⚠️ Repo kulcs letöltés nem sikerült, fallback: keys.openpgp.org"
        if command -v curl &>/dev/null; then
            curl -fsSL "${KOO_URL}" -o "${TMPKEY}"
        else
            wget -qO "${TMPKEY}" "${KOO_URL}"
        fi
    fi

    pacman-key --add "${TMPKEY}"
    rm -f "${TMPKEY}"

    echo "✅ Kulcs importálva: ${KEYID}"
fi

# Trust: locally sign
pacman-key --lsign-key "${KEYID}"
echo "✅ Kulcs locally signed: ${KEYID}"


# 8 XLibre repo kulcs hozzáadása
echo "--> 8 XLibre repo kulcs hozzáadása..."

XLIBRE_KEYID="73580DE2EDDFA6D6"
XLIBRE_KEY_URL="https://x11libre.net/repo/arch_based/x86_64/0x73580DE2EDDFA6D6.gpg"

if pacman-key --list-keys "${XLIBRE_KEYID}" &>/dev/null; then
    echo "✅ XLibre kulcs már létezik a keyringben: ${XLIBRE_KEYID}"
else
    echo "--> XLibre kulcs letöltése és importálása: ${XLIBRE_KEY_URL}"
    TMPKEY="$(mktemp)"

    if command -v curl &>/dev/null; then
        curl -fsSL "${XLIBRE_KEY_URL}" -o "${TMPKEY}"
    else
        wget -qO "${TMPKEY}" "${XLIBRE_KEY_URL}"
    fi

    pacman-key --add "${TMPKEY}"
    rm -f "${TMPKEY}"

    echo "✅ XLibre kulcs importálva: ${XLIBRE_KEYID}"
fi

pacman-key --lsign-key "${XLIBRE_KEYID}"
echo "✅ XLibre kulcs locally signed: ${XLIBRE_KEYID}"


# 9. CachyOS repo kulcs + CPU-specifikus repo blokk beállítása (NINCS csomagtelepítés)
echo "--> 9. CachyOS repo beállítása (CPU detektálás + pacman.conf módosítás)..."
if setup_cachyos_repos_first_run; then
    echo "✅ CachyOS repo beállítás kész."
else
    echo "⚠️ CachyOS repo beállítás sikertelen, a script folytatódik."
fi


# 10. Mirrorok frissítése (KONTINENS ALAPJÁN - Biztonságos és Gyors)
echo "--> 10. Mirrorok frissítése (Helyi kontinens szervereinek keresése)..."

if command -v pacman-mirrors &> /dev/null; then
    # --continent:   Érzékeli a felhasználó kontinensét (pl. Európa vagy Észak-Amerika)
    #                Így kis országokban (mint HU) is lesz bőven tartalék szerver a szomszédoktól.
    # --api:         Frissíti a listát
    # --protocols:   Csak HTTPS
    pacman-mirrors --continent --api --protocols https && pacman -Syy
    
    echo "✅ Mirrorok frissítve (Kontinens szintű lista a biztonság érdekében)."
else
    echo "⚠️ pacman-mirrors nem található."
fi


# Add all normal users to diffusion group for write access
if getent group diffusion >/dev/null; then
    # Hozzáad minden felhasználót, akinek UID-ja 1000 és 65534 között van
    for user in $(getent passwd | awk -F: '$3>=1000 && $3<65534 {print $1}'); do
        usermod -aG diffusion "$user" 2>/dev/null || true
    done
    # Biztosítja a megfelelő jogosultságokat a könyvtáron
    chown -R :diffusion /opt/stable-diffusion-webui-forge
    chmod -R g+w /opt/stable-diffusion-webui-forge
    find /opt/stable-diffusion-webui-forge -type d -exec chmod g+s {} \;
fi


echo "=========================================="
echo "✅ TELEPÍTÉS UTÁNI BEÁLLÍTÁSOK KÉSZEN!"
echo "=========================================="

# 11. ÖNGYILKOS MECHANIZMUS
# Letiltjuk a szolgáltatást, hogy többet ne fusson le
echo "--> Szolgáltatás letiltása a következő bootra..."
systemctl disable manjaro-first-run.service

exit 0
