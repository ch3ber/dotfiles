# Hyprland Bar Refactor Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Replace default rainbow-block Waybar config with a 4-island floating bar using a single cyan accent and glow workspace animations.

**Architecture:** Four `group/*` modules define visual islands (workspaces / media / sysinfo / time). The bar background is transparent; each group gets its own dark semi-transparent background and border-radius via CSS. Animations are pure CSS — no scripts.

**Tech Stack:** Waybar 0.15.0 (group module), JSONC config, GTK CSS

---

## File Map

| File | Action | Responsibility |
|------|--------|---------------|
| `waybar/.config/waybar/config.jsonc` | Full rewrite | Module layout, 4 groups, module options |
| `waybar/.config/waybar/style.css` | Full rewrite | Island shape, colors, hover + glow animations |

---

## Task 1: Backup current configs

**Files:**
- Read: `waybar/.config/waybar/config.jsonc`
- Read: `waybar/.config/waybar/style.css`

- [ ] **Step 1: Commit current state as backup**

```bash
git add waybar/.config/waybar/config.jsonc waybar/.config/waybar/style.css
git commit -m "chore: backup waybar config before island refactor"
```

Expected: commit created with current files as snapshot.

---

## Task 2: Rewrite config.jsonc

**Files:**
- Modify: `waybar/.config/waybar/config.jsonc`

- [ ] **Step 1: Replace entire file with 4-island config**

Full content for `waybar/.config/waybar/config.jsonc`:

```jsonc
// -*- mode: jsonc -*-
{
    "layer": "top",
    "position": "top",
    "height": 36,
    "margin-top": 6,
    "margin-left": 6,
    "margin-right": 6,
    "spacing": 0,

    "modules-left": ["group/left"],
    "modules-center": ["group/media"],
    "modules-right": ["group/sysinfo", "group/time"],

    "group/left": {
        "orientation": "horizontal",
        "modules": ["hyprland/workspaces"]
    },
    "group/media": {
        "orientation": "horizontal",
        "modules": ["pulseaudio", "hyprland/language"]
    },
    "group/sysinfo": {
        "orientation": "horizontal",
        "modules": ["cpu", "memory", "temperature", "backlight", "network", "battery"]
    },
    "group/time": {
        "orientation": "horizontal",
        "modules": ["tray", "clock"]
    },

    "hyprland/workspaces": {
        "format": "{icon}",
        "on-click": "activate",
        "format-icons": {
            "active": "󰮯",
            "occupied": "󰊠",
            "default": "󰊠"
        },
        "sort-by-number": true,
        "all-outputs": false,
        "persistent-workspaces": {
            "*": [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
        }
    },

    "pulseaudio": {
        "format": "{volume}% {icon}",
        "format-bluetooth": "{volume}% {icon} 󰂯",
        "format-muted": "󰝟 muted",
        "format-icons": {
            "headphone": "󰋋",
            "headset": "󰋎",
            "default": ["󰕿", "󰖀", "󰕾"]
        },
        "on-click": "pavucontrol",
        "tooltip": false
    },

    "hyprland/language": {
        "format": "{short}"
    },

    "cpu": {
        "format": "{usage}% 󰻠",
        "tooltip": false,
        "interval": 2
    },

    "memory": {
        "format": "{}% 󰍛",
        "tooltip": false,
        "interval": 2
    },

    "temperature": {
        "critical-threshold": 80,
        "format": "{temperatureC}°C {icon}",
        "format-icons": ["󱃃", "󰔏", "󱃂"],
        "tooltip": true
    },

    "backlight": {
        "format": "{percent}% {icon}",
        "format-icons": ["󰃞", "󰃟", "󰃠"],
        "tooltip": false
    },

    "network": {
        "format-wifi": "{signalStrength}% 󰤨",
        "format-ethernet": "󰈀 connected",
        "format-disconnected": "󰤭 disconnected",
        "tooltip-format": "{ifname} — {ipaddr}/{cidr}",
        "on-click": "nm-connection-editor"
    },

    "battery": {
        "states": {
            "warning": 30,
            "critical": 15
        },
        "format": "{capacity}% {icon}",
        "format-charging": "{capacity}% 󰂄",
        "format-plugged": "{capacity}% 󰚥",
        "format-icons": ["󰁺", "󰁻", "󰁼", "󰁽", "󰁾", "󰁿", "󰂀", "󰂁", "󰂂", "󰁹"],
        "tooltip": true,
        "tooltip-format": "{timeTo}"
    },

    "tray": {
        "spacing": 8,
        "icon-size": 14
    },

    "clock": {
        "format": "{:%H:%M}",
        "format-alt": "{:%Y-%m-%d}",
        "tooltip-format": "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>"
    }
}
```

- [ ] **Step 2: Verify file saved correctly**

```bash
cat waybar/.config/waybar/config.jsonc | head -10
```

Expected: first line is `// -*- mode: jsonc -*-`

---

## Task 3: Rewrite style.css

**Files:**
- Modify: `waybar/.config/waybar/style.css`

- [ ] **Step 1: Replace entire file with island styles**

Full content for `waybar/.config/waybar/style.css`:

```css
* {
    font-family: "Mononoki Nerd Font", "FontAwesome", sans-serif;
    font-size: 13px;
    min-height: 0;
    border: none;
    border-radius: 0;
    box-shadow: none;
}

window#waybar {
    background: transparent;
    color: #cdd6f4;
}

/* Islands */
#left,
#media,
#sysinfo,
#time {
    background: rgba(17, 17, 27, 0.85);
    border-radius: 8px;
    margin: 0 4px;
    padding: 2px 8px;
}

/* Workspaces */
#workspaces {
    background: transparent;
    padding: 0;
    margin: 0;
}

#workspaces button {
    background: transparent;
    color: #585b70;
    padding: 2px 6px;
    border-radius: 6px;
    border: none;
    box-shadow: none;
    transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

#workspaces button.occupied {
    color: #cdd6f4;
}

#workspaces button.active {
    color: #33ccff;
    background: rgba(51, 204, 255, 0.15);
    box-shadow: 0 0 10px rgba(51, 204, 255, 0.6),
                inset 0 0 10px rgba(51, 204, 255, 0.1);
}

#workspaces button.urgent {
    color: #f38ba8;
    background: rgba(243, 139, 168, 0.15);
}

#workspaces button:hover:not(.active) {
    background: rgba(51, 204, 255, 0.08);
    color: #33ccff;
}

/* All right-side modules */
#pulseaudio,
#language,
#cpu,
#memory,
#temperature,
#backlight,
#network,
#battery,
#clock {
    color: #cdd6f4;
    padding: 2px 6px;
    border-radius: 6px;
    transition: background-color 200ms ease, color 200ms ease;
}

#pulseaudio:hover,
#language:hover,
#cpu:hover,
#memory:hover,
#temperature:hover,
#backlight:hover,
#network:hover,
#battery:hover,
#clock:hover {
    background: rgba(51, 204, 255, 0.08);
}

/* Accent */
#clock {
    color: #33ccff;
    font-weight: bold;
}

#network.wifi,
#network.linked {
    color: #33ccff;
}

/* Warning / critical states */
#battery.warning:not(.charging) {
    color: #f9e2af;
}

#battery.critical:not(.charging) {
    color: #f38ba8;
    animation: blink 0.8s steps(2) infinite;
}

#temperature.critical {
    color: #f38ba8;
}

#network.disconnected {
    color: #585b70;
}

@keyframes blink {
    to {
        color: #1e1e2e;
        background: #f38ba8;
    }
}

/* Tray */
#tray {
    padding: 2px 4px;
}

#tray > .passive {
    -gtk-icon-effect: dim;
}

#tray > .needs-attention {
    -gtk-icon-effect: highlight;
}
```

- [ ] **Step 2: Verify file saved correctly**

```bash
wc -l waybar/.config/waybar/style.css
```

Expected: ~120 lines

---

## Task 4: Deploy and verify

**Files:**
- Read: `waybar/.config/waybar/config.jsonc` (verify symlink or copy in `~/.config/waybar/`)

- [ ] **Step 1: Check if waybar config is symlinked**

```bash
ls -la ~/.config/waybar/
```

If symlinked to dotfiles (via stow or manual), changes are already live. If not, copy:

```bash
cp waybar/.config/waybar/config.jsonc ~/.config/waybar/config.jsonc
cp waybar/.config/waybar/style.css ~/.config/waybar/style.css
```

- [ ] **Step 2: Restart Waybar**

```bash
pkill waybar; waybar &
```

Wait 2 seconds. Waybar should appear at top with 4 floating islands.

- [ ] **Step 3: Verify visually**

Check:
- [ ] 4 distinct islands visible with dark background + rounded corners
- [ ] Workspaces show workspace buttons with dim color for empty
- [ ] Active workspace glows cyan
- [ ] Switching workspace triggers glow transition
- [ ] Hover on any module shows subtle cyan highlight
- [ ] Clock is cyan and shows 24h time
- [ ] Network shows signal % with icon when on wifi

- [ ] **Step 4: If Waybar fails to start, check errors**

```bash
waybar 2>&1 | head -30
```

Common issues:
- `group` module not found → Waybar version too old (requires ≥ 0.9.17, you have 0.15.0 so this shouldn't happen)
- Icon not rendering → font missing, replace icon with text fallback in config (e.g. `"󰻠"` → `"CPU"`)
- Module not found → check module name spelling in config

---

## Task 5: Commit

- [ ] **Step 1: Stage and commit**

```bash
git add waybar/.config/waybar/config.jsonc waybar/.config/waybar/style.css
git commit -m "feat(waybar): floating island bar with cyan glow animations

4-island layout: workspaces / media+layout / sysinfo / tray+clock.
Single cyan accent #33ccff, dark semi-transparent islands, glow
effect on active workspace with cubic-bezier transition."
```
