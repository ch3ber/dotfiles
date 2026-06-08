# Hyprland Bar Refactor — Design Spec

**Date:** 2026-06-08
**Tool:** Waybar
**Status:** Approved

---

## Overview

Refactor current default Waybar config into a minimal floating-island bar with a single cyan accent, rounded corners consistent with Hyprland, and glowing workspace animations.

---

## Layout

4 floating islands, position top, 6px margin from screen edge.

```
[ workspaces ]   [ audio · layout ]   [ cpu · ram · temp · brillo · net · bat ]   [ tray · hora ]
```

| Island | Modules |
|--------|---------|
| Left | `hyprland/workspaces` |
| Center-left | `pulseaudio`, `hyprland/language` |
| Center-right | `cpu`, `memory`, `temperature`, `backlight`, `network`, `battery` |
| Right | `tray`, `clock` |

**Removed from current config:** `mpd`, `power-profiles-daemon`, `keyboard-state`, `battery#bat2`, `custom/media`

---

## Module Formats

| Module | Format |
|--------|--------|
| CPU | `{usage}% ` |
| RAM | `{percentage}% ` |
| Temperature | `{temperatureC}°C {icon}` |
| Backlight | `{percent}% ` |
| Network wifi | `{signalStrength}% ` |
| Network ethernet | ` connected` |
| Battery | `{capacity}% {icon}` |
| Clock | `%H:%M` |
| Pulseaudio | `{volume}% {icon}` |
| Language | `{short}` (e.g. `ES`, `EN`) |

**Tooltips:** battery (time remaining), network (IP/interface), temperature (thermal zone)

**Click actions:**
- `pulseaudio` → `pavucontrol`
- `network` → `nm-connection-editor`
- `clock` right-click → alt format `%Y-%m-%d`

---

## Visual Style

### Colors

```css
--bg:     rgba(17, 17, 27, 0.85)   /* dark semi-transparent island background */
--accent: #33ccff                  /* cyan — matches Hyprland active border */
--text:   #cdd6f4                  /* soft white */
--muted:  #585b70                  /* inactive icons and secondary text */
```

### Island Shape

```css
border-radius: 8px;     /* consistent with Hyprland rounding=7 */
padding: 4px 12px;
margin: 6px 3px;        /* top float gap + spacing between islands */
```

No per-module background colors. All modules share island background.

### Accent Usage

`#33ccff` applied only to:
- Active workspace button
- Clock text
- Network when connected

---

## Animations

### Hover (all modules)

```css
transition: background-color 200ms ease, color 200ms ease;
/* on hover: background rgba(51, 204, 255, 0.08) */
```

### Workspace Active — Glow Effect

```css
#workspaces button.active {
    color: #33ccff;
    background: rgba(51, 204, 255, 0.15);
    box-shadow: 0 0 10px rgba(51, 204, 255, 0.6),
                inset 0 0 10px rgba(51, 204, 255, 0.1);
    transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}
```

Glow transitions to new active workspace on change — cyan pulse, visually prominent.

### Workspace States

| State | Style |
|-------|-------|
| Active | `#33ccff` + glow box-shadow |
| Occupied | `#cdd6f4` |
| Empty | `#585b70` |
| Hover (inactive) | `#33ccff` no glow, transition 200ms |

---

## Files to Modify

- `waybar/.config/waybar/config.jsonc` — full rewrite of modules and config
- `waybar/.config/waybar/style.css` — full rewrite of styles
