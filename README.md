# 🌙 HyprLite Rice Framework (HLRF)

A modular, lightweight, performant Hyprland rice for Arch Linux.

> End-4 inspired taskbar · ML4W-style launcher · Catppuccin Mocha · Zero bloat

---

## ✨ Features

| Component | Tool | Notes |
|---|---|---|
| Window Manager | Hyprland | Modular split config |
| Taskbar | Waybar | End-4 pill-grouped design |
| App Launcher | Rofi (wayland) | ML4W centered popup |
| Notifications | SwayNC | Grouped, DnD toggle |
| Lockscreen | Hyprlock | Clock + blur background |
| Idle Manager | Hypridle | Lock 10min, DPMS 15min |
| Wallpaper | Swww | Fade transitions, cycling |
| Screenshots | Grim + Slurp | Area/full/window + clipboard |
| Audio | Pipewire + Wireplumber | Volume OSD |
| Clipboard | cliphist + wl-clipboard | History via Super+Shift+V |
| Theming | Adwaita-dark, Papirus, Bibata | GTK + Qt synced |

---

## 📦 Installation

```bash
git clone https://github.com/YOUR_USER/hypr-lite.git
cd hypr-lite
bash install.sh
```

### Options

| Flag | Description |
|---|---|
| `--dry-run` | Preview all changes without modifying anything |
| `--skip-deps` | Skip dependency installation |
| `--uninstall` | Restore backed-up configs |

### Dependencies Only

```bash
bash dependencies.sh
```

---

## 📂 Config Structure

```
~/.config/
├── hypr/
│   ├── hyprland.conf          # Master config (sources below)
│   ├── animations.conf        # Minimal animations (≤2.5 duration)
│   ├── keybinds.conf          # All keybinds
│   ├── monitors.conf          # Monitor setup
│   ├── rules.conf             # Window/workspace rules
│   ├── autostart.conf         # Autostart services
│   ├── hyprlock.conf          # Lockscreen
│   ├── hypridle.conf          # Idle manager
│   ├── scripts/
│   │   ├── powermenu.sh       # Rofi power dialog
│   │   ├── screenshot.sh      # Area/full/window capture
│   │   ├── wallpaper.sh       # Swww wallpaper cycler
│   │   ├── volume.sh          # Volume OSD
│   │   ├── brightness.sh      # Brightness OSD
│   │   ├── scratchpad.sh      # Scratchpad toggle
│   │   ├── nightlight.sh      # Night light shader
│   │   ├── screenrecord.sh    # wf-recorder toggle
│   │   └── gamemode.sh        # Performance mode
│   └── wallpapers/            # Your wallpapers here
├── waybar/
│   ├── config.jsonc           # Module layout
│   └── style.css              # End-4 pill styling
├── rofi/
│   ├── config.rasi            # Main Rofi config
│   ├── launcher.rasi          # ML4W launcher theme
│   ├── powermenu.rasi         # Power menu theme
│   └── emoji.rasi             # Emoji picker theme
├── swaync/
│   ├── config.json            # Notification settings
│   └── style.css              # Notification styling
├── gtk-3.0/settings.ini
├── gtk-4.0/settings.ini
├── qt5ct/qt5ct.conf
└── qt6ct/qt6ct.conf
```

---

## ⌨️ Keybinds

### Core

| Keybind | Action |
|---|---|
| `Super + Space` | App Launcher (Rofi) |
| `Super + Return` | Terminal (kitty) |
| `Super + Q` | Close Window |
| `Super + F` | Fullscreen |
| `Super + V` | Toggle Float |
| `Super + E` | File Manager |
| `Super + B` | Browser |

### Workspaces

| Keybind | Action |
|---|---|
| `Super + 1-0` | Switch workspace |
| `Super + Shift + 1-0` | Move window to workspace |
| `Super + Scroll` | Cycle workspaces |

### Utilities

| Keybind | Action |
|---|---|
| `Print` | Screenshot (area) |
| `Shift + Print` | Screenshot (full) |
| `Super + X` | Power Menu |
| `Super + S` | Scratchpad |
| `Super + W` | Next Wallpaper |
| `Super + N` | Night Light Toggle |
| `Super + Shift + G` | Game Mode |
| `Super + R` | Screen Record |
| `Super + Delete` | Lock Screen |
| `Super + Shift + V` | Clipboard History |
| `Super + `` ` | Notification Center |

### Window Management

| Keybind | Action |
|---|---|
| `Super + H/J/K/L` | Focus left/down/up/right |
| `Super + Shift + H/J/K/L` | Move window |
| `Super + Ctrl + Arrows` | Resize window |
| `Super + Mouse Drag` | Move window (mouse) |
| `Super + Right Click Drag` | Resize window (mouse) |

---

## ⚡ Performance Targets

| Metric | Target |
|---|---|
| Idle RAM | < 700 MB |
| Waybar RAM | < 60 MB |
| CPU idle | < 3% |
| Launcher start | < 200ms |
| Animation duration | ≤ 2.5 |

Blur and shadows are **disabled by default**. Toggle game mode (`Super + Shift + G`) for maximum performance.

---

## 🎨 Customization

### Change Accent Color

Edit the CSS variable in these files:
- `~/.config/waybar/style.css` → `@define-color accent #YOUR_COLOR;`
- `~/.config/rofi/launcher.rasi` → `accent: #YOUR_COLOR;`
- `~/.config/swaync/style.css` → accent color values

### Nvidia Users

Uncomment the Nvidia env vars in `~/.config/hypr/hyprland.conf`:
```conf
env = LIBVA_DRIVER_NAME,nvidia
env = __GLX_VENDOR_LIBRARY_NAME,nvidia
env = GBM_BACKEND,nvidia-drm
env = WLR_NO_HARDWARE_CURSORS,1
```

### Multi-Monitor

Edit `~/.config/hypr/monitors.conf` — examples included in comments.

---

## 🔧 Troubleshooting

| Issue | Fix |
|---|---|
| No cursor | Enable `WLR_NO_HARDWARE_CURSORS=1` in hyprland.conf |
| Waybar not showing | Run `waybar` manually to see errors |
| Rofi styling wrong | Ensure `rofi-wayland` is installed, not `rofi` |
| Screen not locking | Check `hypridle` is running: `pgrep hypridle` |
| Wallpaper not loading | Ensure `swww-daemon` is running and wallpapers exist |

---

## 📄 License

MIT — Use, modify, and distribute freely.
