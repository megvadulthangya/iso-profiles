# 🏔️ Manjaro Awesome Respin — NVIDIA 340 Legacy

![Maintenance Status](https://img.shields.io/badge/Maintenance-Actively%20maintained%20via%20automated%20CI%2FCD%20pipeline-brightgreen)

> ⚠️ **NVIDIA 340.108 — SPECIAL HARDWARE BUILD**
>
> **Ez az ISO kifejezetten olyan NVIDIA videokártyákhoz készült, amelyekhez a zárt NVIDIA 340.108 driver szükséges.**
>
> A rendszer a `xlibre-xserver-legacyabi` csomagot használja a normál `xlibre-xserver` helyett.
>
> **Ha a videokártyád egy másik NVIDIA driverágat igényel (például 390xx, 470xx, 580xx vagy az aktuális driver), ezt az ISO-t ne válaszd.** A 340-es driverre és legacy ABI-ra épülő rendszerben az OpenGL szoftveres renderelésre (`llvmpipe`) eshet vissza.
>
> **Ha csak Intel vagy AMD grafikus vezérlőd van, és nincs NVIDIA 340.108-at igénylő kártyád, a normál kiadást válaszd.**
>
> Ellenőrzés X11-en: `glxinfo -B | grep -i 'OpenGL renderer'`>
> ---
>
> ⚠️ **NVIDIA 340.108 — SPECIAL HARDWARE BUILD**
>
> **This ISO is specifically intended for NVIDIA graphics cards that require the proprietary NVIDIA 340.108 driver.**
>
> It ships `xlibre-xserver-legacyabi` instead of the standard `xlibre-xserver`.
>
> **If your NVIDIA GPU requires a different driver branch (e.g. 390xx, 470xx, 580xx, or the current driver), do not use this ISO.** OpenGL may fall back to software rendering (`llvmpipe`) with this legacy-ABI stack.
>
> Systems using only Intel or AMD graphics, without an NVIDIA GPU requiring driver 340.108, should use a standard edition.
>
> Check the OpenGL renderer under X11: `glxinfo -B | grep -i 'OpenGL renderer'`
## 📦 Build Info

- **Date:** {{BUILD_DATE}}
- **Version:** {{VERSION}}
- **Branch:** Manjaro TESTING
- **Kernel:** linux6.18
- **Stack:** `{{STACK_SLUG}}`
- **Desktop:** AwesomeWM 4.x (GitHub version)
- **Theme:** Unified Nordic color scheme

---

## ⚙️ Overview / Áttekintés

Custom Manjaro Linux ISO — NVIDIA 340.108 legacy stack, Manjaro Testing branch, Nordic themed AwesomeWM.

Ez egy egyedi Manjaro Linux ISO — NVIDIA 340.108 legacy stack, Manjaro Testing ág, Nordic témájú AwesomeWM.

---

## 🚀 Key Features / Főbb jellemzők

### 🖥️ Desktop Environment
- **Window Manager:** AwesomeWM 4.x (GitHub version)
- **Theme:** Unified **Nordic** color scheme
- **Photography Ready:** Darktable database with Stefano Ferro & t3mujinpack styles

### 🛠️ System Core
- **Base:** Manjaro Testing
- **Filesystem:** BTRFS + Timeshift (automatic snapshots)
- **Shell:** Fish (root), Zsh/Bash (user)

### 🎮 NVIDIA Legacy 340 Stack
- **Driver:** NVIDIA 340.108 (Debian patchset based)
- **X server:** `xlibre-xserver-legacyabi` (legacy ABI)
- **mhwd:** `video-nvidia-340xx` and `hybrid-intel-nvidia-340xx-bumblebee` profiles
- **Tested kernels:** 6.1 / 6.1-rt / 6.6 / 6.6-rt / 6.12 / 6.12-rt / 6.18 / 7.1 / 7.2 / 7.3-rc
---

## 📥 Alternative downloads

- **Modern NVIDIA stack (390 / 470 / 580 / latest):** [testing-nvidia-stack](https://sourceforge.net/projects/manjaro-awesome-iso/files/Releases/testing-nvidia-stack/)
- **AI/ML stack (WIP):** [ai-ml-stack](https://sourceforge.net/projects/manjaro-awesome-iso/files/Releases/ai-ml-stack/)
- **Intel/AMD or VM:** [lite-no-nvidia-stack](https://sourceforge.net/projects/manjaro-awesome-iso/files/Releases/lite-no-nvidia-stack/)

---

## 📺 Video Walkthrough / Videós bemutató

[![Manjaro Awesome Respin Showcase](https://img.youtube.com/vi/7Z-CN08_2U8/maxresdefault.jpg)](https://youtu.be/7Z-CN08_2U8)

---

## ☕ Support / Támogatás

👉 [Buy me a coffee](https://buymeacoffee.com/rohambili)

---

## 🧠 Credits / Készítette

- **Base:** [Manjaro Linux](https://manjaro.org/)
- **Respin by:** [@megvadulthangya](https://github.com/megvadulthangya)

---

## 📖 Részletek / Details

👉 [NVIDIA 340.108 / 390.157 legacy drivers — Debian-based patchset (Manjaro Forum)](https://forum.manjaro.org/t/nvidia-340-108-390-157-legacy-drivers-debian-based-patchset-complete-package-set-mhwd-integration-and-live-isos)
