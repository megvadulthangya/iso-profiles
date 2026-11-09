# 🏔️ Manjaro Awesome Respin - Nordic Themed

![Maintenance Status](https://img.shields.io/badge/Maintenance-Actively%20maintained%20via%20automated%20CI%2FCD%20pipeline-brightgreen)

## 📦 Build Info

- **Date:** `{{BUILD_DATE}}`
- **Version:** `{{VERSION}}`
- **Branch:** Manjaro TESTING
- **Kernel:** `linux6.18`
- **WM:** Awesome + Picom-pijulius
- **Theme:** Unified Nordic color scheme

---

## 🛠️ TESTING KIADÁS / TESTING RELEASE

**EGYSÉGES NVIDIA KIADÁS / UNIFIED NVIDIA RELEASE**

**Ez egy egyedi Manjaro Linux ISO, amely az AwesomeWM ablakkezelőre, az egységes Nordic megjelenésre és a gondosan összeállított asztali környezetre épül. A rendszer a Manjaro TESTING ágat használja.**

**A custom Manjaro Linux ISO built around AwesomeWM, a unified Nordic look, and a carefully curated desktop environment. The system tracks the Manjaro TESTING branch.**

This is the single current Awesome ISO. It includes support for both legacy and modern NVIDIA driver branches. The separate NVIDIA 340 legacy ISO has been retired; the 340 driver is included in this main ISO.

---

## ⚙️ Overview / Áttekintés

A respin célja egy egységes megjelenésű, személyre szabott AwesomeWM-környezet, billentyűzetközpontú munkafolyamattal és előre összeállított eszközkészlettel.

This respin brings together a customized AwesomeWM environment, a keyboard-focused workflow, coordinated Nordic styling, and a curated set of desktop and command-line tools.

---

## 🚀 Key Features / Főbb jellemzők

### 🖥️ Desktop Environment

- **Window Manager:** AwesomeWM 4.x, customized configuration.
- **Theme:** Unified **Nordic** color scheme and coordinated icons.
- **Picom:** `picom-pijulius-next-git`, with a GPU-detection script that selects a suitable configuration for the detected hardware.
- **Darktable:** Pre-populated with Stefano Ferro styles and t3mujinpack film emulations. The selection is optimized for Sony Alpha photography but can also be used with other cameras.

### 🛠️ System Core

- **Base:** Manjaro TESTING.
- **Kernel:** Linux `6.18`.
- **Filesystem:** BTRFS with Timeshift snapshot support.
- **Display Manager:** LightDM with GTK greeter.
- **Shells:** Fish for root; Zsh and Bash for the regular user workflow.
- **Command-line tools:** A curated set including `bat`, `eza`, `fzf`, `zoxide`, `fd`, `ripgrep`, `ripgrep-all`, `jq`, and `tldr`.

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

## 💻 Tested on Low-End Hardware

The desktop has been tested on an **ASUS Eee PC X101** with a 1.33 GHz CPU and 2 GB RAM, where it ran smoothly in my testing.

---

## 📺 Video Walkthrough / Videós bemutató

[![Manjaro Awesome Respin Showcase](https://img.youtube.com/vi/7Z-CN08_2U8/maxresdefault.jpg)](https://youtu.be/7Z-CN08_2U8)

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

*🧪 AI/ML stack: work in progress (WIP). No finished, ready-to-use ISO is currently published.*
