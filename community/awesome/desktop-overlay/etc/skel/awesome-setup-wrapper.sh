#!/bin/bash
# awesome-setup-wrapper.sh
# Prevent execution in live environment or by 'manjaro' user

# 1️⃣ Skip if the username is 'manjaro'
if [ "$USER" = "manjaro" ]; then
    echo "Live user 'manjaro' detected. Skipping Awesome WM setup."
    exit 0
fi

# 2️⃣ Function to detect live environment by filesystem and boot parameters
detect_live_environment() {
    # Root mounted from squashfs or overlay
    if mount | grep -Eq "on / .*squashfs|on / .*overlay"; then
        return 0
    fi

    # Presence of common live indicators
    if grep -Eq "boot=live|cowspacesize|toram|casper" /proc/cmdline; then
        return 0
    fi

    # Check if /run/initramfs/live or similar exists
    if [ -d /run/initramfs/live ] || [ -f /cdrom/casper/filesystem.squashfs ]; then
        return 0
    fi

    return 1  # not live
}

# 3️⃣ Run detection
if detect_live_environment; then
    echo "Live environment detected. Skipping Awesome WM setup."
    exit 0
fi

# 4️⃣ If everything is fine, launch setup terminal
xfce4-terminal \
    --title="Awesome WM Setup" \
    --geometry=80x25 \
    -e "/bin/bash -c '$HOME/awesome-setup.sh; bash'"
