# 🏔️ Manjaro XFCE Respin — Nordic Themed

![Maintenance Status](https://img.shields.io/badge/Maintenance-Actively%20maintained%20via%20automated%20CI%2FCD%20pipeline-brightgreen)

## 📦 Build Info

- **Date:** `{{BUILD_DATE}}`
- **Version:** `{{VERSION}}`
- **Branch:** Manjaro TESTING
- **Kernel:** `linux6.18`
- **Desktop:** XFCE 4.x + Compiz
- **Theme:** Unified Nordic color scheme

---

## 🛠️ TESTING KIADÁS / TESTING RELEASE

**EGYSÉGES NVIDIA KIADÁS / UNIFIED NVIDIA RELEASE**

**Ez az egyedi Manjaro Linux ISO az XFCE asztali környezetet a Compiz látványos ablakeffektjeivel és az egységes Nordic megjelenéssel ötvözi. A rendszer a Manjaro TESTING ágra épül.**

**A custom Manjaro Linux ISO combining the XFCE desktop with Compiz visual effects and a unified Nordic look. The system is based on the Manjaro TESTING branch.**

This is the single current XFCE ISO. It includes support for both legacy and modern NVIDIA driver branches. The separate NVIDIA 340 legacy ISO has been retired; the 340 driver is included in this main ISO.

---

## ⚙️ Overview / Áttekintés

A projekt az XFCE hagyományos asztali környezetét egészíti ki a Compiz animált és 3D effektjeivel, egységes Nordic megjelenésbe rendezve.

This respin combines the familiar XFCE desktop with Compiz's animated and 3D effects, all within a coordinated Nordic theme.

---

## 🚀 Key Features / Főbb jellemzők

### 🖥️ Desktop Environment

- **Desktop:** XFCE 4.x
- **Window Manager:** Compiz with animated and 3D desktop effects
- **Theme:** Unified **Nordic** color scheme

### ⚡ Compiz Effects & Performance

Compiz adds animated window transitions, transparency, and 3D desktop effects. This makes the desktop more visually dynamic than a conventional XFCE setup, but graphics performance matters.

**A smooth experience is not guaranteed on every system.** Compiz relies on working hardware-accelerated OpenGL. Performance depends on the GPU, graphics driver, display resolution, and enabled effects. Older or low-powered graphics hardware may experience stuttering, and some effects may not work correctly.

A Compiz által kínált látványos effektekhez megfelelő grafikus gyorsítás szükséges; gyengébb hardveren a működés akadozhat.

### 🛠️ System Core

- **Base:** Manjaro TESTING
- **Kernel:** Linux `6.18`
- **Filesystem:** BTRFS + Timeshift snapshot support
- **Display Manager:** LightDM with GTK greeter
- **Shells:** Fish for root; Zsh and Bash for the regular user workflow

### 🎮 NVIDIA Driver Support

The ISO includes the following NVIDIA driver branches:

- **340.108** — legacy, independently maintained
- **390.157** — legacy, independently maintained
- **470.xx** — legacy, provided by the official Manjaro repositories
- **580.xx** — legacy, provided by the official Manjaro repositories
- **Latest available branch** — provided by the official Manjaro repositories

### 🧰 NVIDIA 340xx / 390xx Legacy Driver Maintenance

I maintain both the **NVIDIA 340.108 and 390.157 legacy drivers** in my own Manjaro/Arch Linux repositories, including their driver packages and kernel module patchsets.

Both patchsets are based on Debian's NVIDIA kernel patch series, with additional Manjaro/Arch Linux adaptations and ongoing kernel compatibility work.

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
