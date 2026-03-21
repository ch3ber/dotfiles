#!/bin/bash
# ──────────────────────────────────────────────────────────
# ch3ber dotfiles — dependency installer (CachyOS / Arch)
# Copy-paste the section you need into your terminal.
# ──────────────────────────────────────────────────────────

# ── Shared (always needed) ────────────────────────────────
sudo pacman -S --needed \
  git curl stow base-devel \
  zsh alacritty tmux \
  lsd bat fzf acpi \
  ttf-mononoki-nerd ttf-ubuntu-mono-nerd

# ── Option A: bspwm (X11) ────────────────────────────────
sudo pacman -S --needed \
  bspwm sxhkd polybar picom \
  rofi feh xclip spectacle cava

# ── Option B: hyprland (Wayland) ──────────────────────────
sudo pacman -S --needed \
  hyprland hyprpaper hyprlauncher waybar dunst \
  grim slurp wl-clipboard

# ── Optional apps ─────────────────────────────────────────
# sudo pacman -S --needed playerctl brightnessctl pavucontrol nautilus
