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

This is the single current XFCE ISO. It includes support for both legacy and modern NVIDIA driver branches; a separate NVIDIA 340 legacy ISO is no longer maintained.

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
- **Shells:** Fish for root; Zsh/Bash for the regular user workflow

### 🎮 NVIDIA Driver Support

The ISO includes legacy and modern NVIDIA driver branches:

- **340.108** — legacy
- **390.157** — legacy
- **470.xx** — legacy
- **580.xx** — legacy
- **Latest available branch**

The separate NVIDIA 340 legacy ISO has been retired. The 340 driver is now included in the main XFCE ISO.

### 🧪 NVIDIA Open Kernel Module Testing

If you have a modern NVIDIA GPU that supports the **Open Kernel Module**, please help test the live ISO on bare metal.

After booting, check which NVIDIA kernel module is actually loaded:

```bash
cat /proc/driver/nvidia/version
```

If the Open Kernel Module was loaded, the output should identify it as **Open Kernel Module**.

You can also check the detected driver profile with:

```bash
nvidia-driver-assistant --mhwd
```

Please report whether the expected Open Kernel Module was loaded successfully, together with your GPU model and the command output. This feedback helps verify the NVIDIA driver selection on different hardware.

### 🔧 NVIDIA 390xx Kernel Patch Maintenance

Ongoing maintenance and forward-porting of a Debian-derived kernel patchset for the **NVIDIA 390xx legacy driver**, adapted for Manjaro/Arch Linux.

The patchset work extends through Linux 7.3 and continues into `linux-next`. This refers to the 390xx kernel-patch work, not the kernel bundled with this ISO.

🔗 **Details / Részletek:** [NVIDIA 340.108 / 390.157 Legacy Drivers — Debian-based Patchset](https://forum.manjaro.org/t/nvidia-340-108-390-157-legacy-drivers-debian-based-patchset-complete-package-set-mhwd-integration-and-live-isos)

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
