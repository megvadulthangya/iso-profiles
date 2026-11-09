# 🏔️ Manjaro GNOME Respin — Nordic Themed

## 📦 Build Info

- **Date:** `{{BUILD_DATE}}`
- **Version:** `{{VERSION}}`
- **Branch:** Manjaro TESTING
- **Kernel:** `linux6.18`
- **Desktop:** GNOME
- **Theme:** Unified Nordic color scheme

---

## 🛠️ TESTING KIADÁS / TESTING RELEASE

**EGYSÉGES NVIDIA KIADÁS / UNIFIED NVIDIA RELEASE**

**Ez az egyedi Manjaro Linux ISO a GNOME asztali környezetet ötvözi az egységes Nordic megjelenéssel. A rendszer a Manjaro TESTING ágra épül, mindennapi asztali használatra.**

**This custom Manjaro Linux ISO combines the GNOME desktop with a unified Nordic look. Based on the Manjaro TESTING branch, it is intended for everyday desktop use.**

### ⚠️ IMPORTANT — NVIDIA HARDWARE REQUIREMENT

**This GNOME ISO is intended only for systems with NVIDIA GPUs supported by the NVIDIA 580 driver branch or newer.**

Although NVIDIA 340, 390 and 470 driver packages are included in the ISO, **this GNOME release is NOT intended for graphics cards that require any of these older driver branches.**

**If your NVIDIA GPU requires the 340, 390 or 470 driver, DO NOT use this ISO.** These older branches predate NVIDIA's GBM support and do not provide the GBM backend expected by the modern GNOME Wayland graphics stack.

Please use the Awesome or XFCE respin instead if your hardware depends on one of these older NVIDIA driver branches.

---

## ⚙️ Overview / Áttekintés

A projekt célja egy egységes megjelenésű Manjaro-környezet a GNOME asztali felülettel és a hozzá illeszkedő Nordic témával.

A Manjaro-based desktop featuring GNOME with a coordinated Nordic theme and a consistent visual style.

---

## 🚀 Key Features / Főbb jellemzők

### 🖥️ Desktop Environment

- **Desktop:** GNOME
- **Theme:** Unified **Nordic** color scheme

### 🛠️ System Core

- **Base:** Manjaro TESTING
- **Kernel:** Linux `6.18`
- **Filesystem:** BTRFS + Timeshift snapshot support
- **Shells:** Fish for root; Zsh/Bash for the regular user workflow

### 🎮 NVIDIA Driver Support

The ISO includes the following NVIDIA driver branches:

- **340.108** — legacy, independently maintained
- **390.157** — legacy, independently maintained
- **470.xx** — legacy, provided by the official Manjaro repositories
- **580.xx** — legacy, provided by the official Manjaro repositories
- **Latest available branch** — provided by the official Manjaro repositories

**Important:** The inclusion of older driver packages does not mean this GNOME ISO is suitable for GPUs that require them. See the hardware warning above.

### 🛠️ NVIDIA 340xx / 390xx Legacy Driver Maintenance

I maintain both the **NVIDIA 340.108 and 390.157 legacy drivers** in my own Manjaro/Arch Linux repositories, including their driver packages and kernel module patchsets.

Both patchsets are based on Debian's NVIDIA kernel patch series, with additional Manjaro/Arch Linux adaptations and ongoing kernel compatibility work.

Both driver branches are maintained with Debian-based kernel patchsets and additional Manjaro/Arch Linux adaptations to address kernel API changes.

Build testing on Manjaro has covered the following kernel versions and variants:

- Linux 6.1 / 6.1-rt
- Linux 6.6 / 6.6-rt
- Linux 6.12 / 6.12-rt
- Linux 6.18
- Linux 7.1
- Linux 7.2
- Linux 7.3
- Linux 7.4-rc
- Linux 7.4-rc-next

The tested list represents the Manjaro build-test coverage, not a hard upper limit on potential kernel compatibility. The patchsets are adapted to kernel changes as they evolve.

### 🧠 NVIDIA Driver Assistant & MHWD Integration

This ISO includes my Manjaro-specific fork of [nvidia-driver-assistant](https://github.com/megvadulthangya/nvidia-driver-assistant/tree/manjaro), integrated with MHWD.

It detects NVIDIA GPUs, evaluates their architecture and legacy driver requirements, and recommends the appropriate driver branch and kernel module flavour (Open or proprietary).

The integration allows MHWD to use these recommendations when selecting the matching driver configuration and kernel module package.

The assistant supports NVIDIA driver selection across the branches available in this Manjaro setup: the independently maintained **340xx and 390xx legacy branches**, alongside the **470xx, 580xx and latest branches provided by the official Manjaro repositories**.

### 🧪 NVIDIA Open Kernel Module Testing

If you have a modern NVIDIA GPU that supports the **Open Kernel Module**, please help test the live ISO on bare metal.

Run the NVIDIA Driver Assistant:

```bash
nvidia-driver-assistant
```

It detects your GPU, recommends the appropriate kernel module flavour (Open or proprietary), and displays the corresponding installation instructions.

To verify which NVIDIA kernel module is actually loaded, also run:

```bash
cat /proc/driver/nvidia/version
```

If the Open Kernel Module was loaded, its output should identify it as **Open Kernel Module**.

Please report your GPU model, ISO version, the assistant's recommendation, and the loaded module information.

This feedback helps verify NVIDIA driver detection and Open Kernel Module selection on real hardware.

---

## ☕ Support / Támogatás

👉 [Buy me a coffee](https://buymeacoffee.com/rohambili)

**Feedback, bug reports & testing:**  
Found a problem or tested the ISO? Please [open a new issue on GitHub](https://github.com/megvadulthangya/iso-profiles/issues/new).

For NVIDIA Open Kernel Module testing, please include your GPU model, ISO version, and the relevant command outputs.

---

## 🧠 Credits / Készítette

- **Base:** [Manjaro Linux](https://manjaro.org/)
- **Respin by:** [@megvadulthangya](https://github.com/megvadulthangya)

---
