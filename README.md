![Maintenance Status](https://img.shields.io/badge/Maintenance-Actively%20maintained%20via%20automated%20CI%2FCD%20pipeline-brightgreen)
# 🏔️ Awesome Manjaro Edition

**My personal, unified system installer - Create the same consistent AwesomeWM environment across all my devices.**

[![Download manjaro-awesome-iso](https://a.fsdn.com/con/app/sf-download-button)](https://sourceforge.net/projects/manjaro-awesome-iso/files/latest/download)

---

## ⚙️ Overview / Áttekintés

This project is a **custom Manjaro Linux ISO** designed for a cohesive, visually harmonious, and ready-to-work environment.

**New in this release:** The installation process is now seamless. **No post-install scripts, no hacks.** Just install via Calamares, reboot, and the system is fully configured and ready to use.

Ez a projekt egy **egyedi Manjaro Linux ISO**, amelyet egy egységes, vizuálisan harmonikus és munkára kész környezetnek terveztem.

**Újdonság:** A telepítési folyamat mostantól teljesen zökkenőmentes. **Nincsenek utólagos scriptek, nincsenek "hack"-ek.** Csak telepítsd a szokásos módon, indítsd újra, és a rendszer azonnal használatra kész.

---

## 🚀 Key Features / Főbb jellemzők

### 🖥️ Desktop Environment
* **Window Manager:** AwesomeWM 4.x (Custom Fork)
* **Theme:** Unified **Nordic** color scheme across GTK, Kvantum, LightDM, and AwesomeWM.
* **Wallpapers:** Curated collection "Norded" via ImageGoNord (Sources: Reddit, Unsplash, Wallhaven).
* **Applets:** **Awesome-rofi** fork, patched for seamless integration.

### 📸 Creative Suite (Photography)
The ISO comes with a pre-populated **Darktable database**. You only need to install the software (`sudo pacman -S darktable`), and the presets are instantly available.
* **Stefano Ferro's Styles:** Includes Traveller, Vintage, Dark Tones, Dodge & Burn, RGB Curves, and Urban Style packages.
* **Perfect for Sony Alpha users (optimized for A7II) but works universally.*
* **t3mujinpack:** Extensive film emulation pack (Fuji Velvia, Kodachrome, Ilford B&W, etc.).


### 🛠️ System Core
* **Base:** Manjaro Stable
* **Filesystem:** BTRFS + Timeshift (automatic snapshot management).
* **Shell:** Fish (root), Zsh/Bash (user).

---

## 🧩 Detailed Components / Részletes összetevők

### 1. Awesome WM Nordic Copycats (Fork)
* **Source:** [megvadulthangya/awesome-copycats-manjaro](https://github.com/megvadulthangya/awesome-copycats-manjaro)
* **Description:** A modified version of the original Copycats themes. Every element has been recolored to strictly follow the Nordic palette.
* **Features:**
    * Autohide widgets & Autostart windowless processes
    * Quake drop-down terminal
    * Fast MPD and volume shortcuts
    * Dynamic tagging & On-the-fly useless gaps resize
    * Mouse-driven calendar & Notifications (battery, volume, mail)
    * Freedesktop.org compliant menu

### 2. Nordic Wallpapers & Rofi
* **Wallpapers:** A hand-picked collection from Christian Chiarulli, ThePrimeagen, and various art communities, color-graded to Nordic standards.
* **Rofi:** Forked from `awesome-rofi` to fix compatibility issues within this specific environment. Includes custom Applets, Launchers & Powermenus.

### 3. Darktable Presets Integration
I have integrated a professional library of styles directly into the ISO's configuration.
* **Why?** To speed up photo editing workflows immediately after installation.
* **Included:**
    * *Stefano Ferro's Collection:* Vintage, Urban, Travel, and Dark Tones styles.
    * *t3mujinpack:* The definitive open-source film simulation pack (Kodak, Fuji, Agfa, Ilford emulations).
* **How to use:** Simply install Darktable. The database is already in `~/.config/darktable/`.

---
## 📺 Video Walkthrough / Videós bemutató
Watch the installation and setup guide:
Tekintsd meg a telepítési és beállítási útmutatót:

[![Manjaro Awesome Edition Showcase](https://img.youtube.com/vi/7Z-CN08_2U8/maxresdefault.jpg)](https://youtu.be/7Z-CN08_2U8)
---

## 🪄 Installation / Telepítés

1.  **Download:** Grab the ISO from [SourceForge](https://sourceforge.net/projects/manjaro-awesome-iso/files/latest/download).
2.  **Boot:** Start the Live System.
3.  **Install:** Run the standard Manjaro installer (Calamares).
4.  **Reboot & Enjoy:** No further setup required. The environment is exactly as shown in the screenshots.

1.  **Letöltés:** Töltsd le az ISO-t a [SourceForge](https://sourceforge.net/projects/manjaro-awesome-iso/files/latest/download)-ról.
2.  **Boot:** Indítsd el a Live rendszert.
3.  **Telepítés:** Futtasd a szokásos Manjaro telepítőt.
4.  **Használat:** Újraindítás után a rendszer azonnal kész. Nincs szükség további beállításra.

---

## 🧩 Extra Feature — "Install XLibre"

> **Note:** Available in the installed system via Manjaro Hello.

* Adds XLibre repository & GPG key.
* Replaces Xorg configuration for specific hardware setups.
* Accessible via the custom "Install XLibre" button in the Welcome screen.

---

## ☕ Support / Támogatás

If you find this project useful, please support the development:
Ha hasznosnak találod a projektet, támogasd a fejlesztést:

👉 [Buy me a coffee](https://buymeacoffee.com/rohambili)

---

## 🧠 Credits / Készítette

**Built upon / Alapjául szolgált:**
* 🐧 [Manjaro Linux](https://manjaro.org/)
* 🎨 [Nordic Theme](https://github.com/EliverLara/Nordic)
* ⚡ [AwesomeWM Copycats](https://github.com/lcpz/awesome-copycats) & [Luca CPZ](https://github.com/lcpz)

**Photography Tools / Fotós eszközök:**
* 📷 [Stefano Ferro (MEL365)](https://mel365.com/) - Presets & Styles
* 🎞️ [t3mujinpack](https://t3mujinpack.github.io/) - Film emulation

**Custom integration / Egyedi integráció:**
* 👨💻 [@megvadulthangya](https://github.com/megvadulthangya)
