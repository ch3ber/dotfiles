#!/bin/bash

set -e

DOTFILES_DIR="$HOME/dotfiles"
DOTFILES_REPO="https://github.com/ch3ber/dotfiles.git"

# Colors
RED='\e[31m'
GREEN='\e[32m'
YELLOW='\e[33m'
CYAN='\e[36m'
BOLD='\e[1m'
RESET='\e[0m'

print_header() {
  printf "\n${CYAN}${BOLD}%s${RESET}\n" "$1"
}

print_success() {
  printf "${GREEN}%s${RESET}\n" "$1"
}

print_warning() {
  printf "${YELLOW}%s${RESET}\n" "$1"
}

print_error() {
  printf "${RED}%s${RESET}\n" "$1"
}

# Check if running on Arch Linux
check_arch() {
  if ! command -v pacman &>/dev/null; then
    print_error "This script only supports Arch Linux (pacman not found)."
    exit 1
  fi
}

# Package groups: name|description|pacman_packages|aur_packages|stow_dirs
declare -A PKG_NAMES PKG_DESCS PKG_PACMAN PKG_AUR PKG_STOW PKG_SELECTED

PACKAGES=(zsh neovim alacritty bspwm hyprland polybar waybar picom)

PKG_NAMES[zsh]="zsh"
PKG_DESCS[zsh]="Zsh shell + Oh My Zsh"
PKG_PACMAN[zsh]="zsh fzf"
PKG_STOW[zsh]="zsh"

PKG_NAMES[neovim]="neovim"
PKG_DESCS[neovim]="Neovim editor"
PKG_PACMAN[neovim]="neovim ripgrep"
PKG_STOW[neovim]="nvim"

PKG_NAMES[alacritty]="alacritty"
PKG_DESCS[alacritty]="Alacritty terminal"
PKG_PACMAN[alacritty]="alacritty"
PKG_STOW[alacritty]="alacritty"

PKG_NAMES[bspwm]="bspwm (X11)"
PKG_DESCS[bspwm]="Tiling WM for X11 + sxhkd"
PKG_PACMAN[bspwm]="bspwm sxhkd rofi feh xclip spectacle"
PKG_STOW[bspwm]="bspwm sxhkd"

PKG_NAMES[hyprland]="hyprland (Wayland)"
PKG_DESCS[hyprland]="Hyprland compositor for Wayland"
PKG_PACMAN[hyprland]="hyprland hyprlauncher dunst grim slurp wl-clipboard"
PKG_STOW[hyprland]="hyprland"

PKG_NAMES[polybar]="polybar (X11)"
PKG_DESCS[polybar]="Status bar for X11"
PKG_PACMAN[polybar]="polybar"
PKG_STOW[polybar]="polybar"

PKG_NAMES[waybar]="waybar (Wayland)"
PKG_DESCS[waybar]="Status bar for Wayland"
PKG_PACMAN[waybar]="waybar"
PKG_STOW[waybar]="waybar"

PKG_NAMES[picom]="picom (X11)"
PKG_DESCS[picom]="Compositor for X11"
PKG_PACMAN[picom]="picom"
PKG_STOW[picom]="picom"

# Initialize all as selected
for pkg in "${PACKAGES[@]}"; do
  PKG_SELECTED[$pkg]=1
done

# Interactive package selector
select_packages() {
  while true; do
    clear
    printf "${BOLD}${CYAN}"
    printf "   ___  _  _ ____  ____  ____  ____\n"
    printf "  / __)| || ||__ / | __ )| ___||  _ \\ \n"
    printf " | |   | || |_ |_ \\|  _ \\| __| | |_) |\n"
    printf " | |__ |__  _|__) || |_) | |___|  _ < \n"
    printf "  \\___/   |_||____/|____/|_____|_| \\_\\ \n"
    printf "${RESET}\n"
    printf "${BOLD} dotfiles installer${RESET}\n"
    printf " ─────────────────────────────────────\n\n"
    printf " Select packages to install:\n\n"

    for i in "${!PACKAGES[@]}"; do
      local pkg="${PACKAGES[$i]}"
      local num=$((i + 1))
      if [[ "${PKG_SELECTED[$pkg]}" == "1" ]]; then
        printf "  ${GREEN}[x]${RESET} ${BOLD}%d.${RESET} %-25s %s\n" "$num" "${PKG_NAMES[$pkg]}" "${PKG_DESCS[$pkg]}"
      else
        printf "  ${RED}[ ]${RESET} ${BOLD}%d.${RESET} %-25s %s\n" "$num" "${PKG_NAMES[$pkg]}" "${PKG_DESCS[$pkg]}"
      fi
    done

    printf "\n ─────────────────────────────────────\n"
    printf " Toggle: ${BOLD}1-%d${RESET} | ${BOLD}a${RESET}=all | ${BOLD}n${RESET}=none | ${BOLD}d${RESET}=done | ${BOLD}q${RESET}=quit\n" "${#PACKAGES[@]}"
    printf "\n > "
    read -r choice

    case "$choice" in
      a|A)
        for pkg in "${PACKAGES[@]}"; do PKG_SELECTED[$pkg]=1; done
        ;;
      n|N)
        for pkg in "${PACKAGES[@]}"; do PKG_SELECTED[$pkg]=0; done
        ;;
      d|D)
        break
        ;;
      q|Q)
        printf "\n"
        print_warning "Installation cancelled."
        exit 0
        ;;
      *[0-9]*)
        local idx=$((choice - 1))
        if [[ $idx -ge 0 && $idx -lt ${#PACKAGES[@]} ]]; then
          local pkg="${PACKAGES[$idx]}"
          if [[ "${PKG_SELECTED[$pkg]}" == "1" ]]; then
            PKG_SELECTED[$pkg]=0
          else
            PKG_SELECTED[$pkg]=1
          fi
        fi
        ;;
    esac
  done
}

# Collect all pacman packages from selected groups
collect_packages() {
  local all_pacman=""
  for pkg in "${PACKAGES[@]}"; do
    if [[ "${PKG_SELECTED[$pkg]}" == "1" ]]; then
      all_pacman+=" ${PKG_PACMAN[$pkg]}"
    fi
  done
  echo "$all_pacman"
}

# Collect all stow directories from selected groups
collect_stow_dirs() {
  local all_stow=""
  for pkg in "${PACKAGES[@]}"; do
    if [[ "${PKG_SELECTED[$pkg]}" == "1" ]]; then
      all_stow+=" ${PKG_STOW[$pkg]}"
    fi
  done
  echo "$all_stow"
}

# Install yay (AUR helper)
install_yay() {
  if command -v yay &>/dev/null; then
    print_success "yay is already installed."
    return
  fi
  print_header "Installing yay (AUR helper)..."
  local tmpdir
  tmpdir=$(mktemp -d)
  git clone https://aur.archlinux.org/yay.git "$tmpdir/yay"
  cd "$tmpdir/yay"
  makepkg -si --noconfirm
  cd -
  rm -rf "$tmpdir"
}

# Install Nerd Fonts
install_fonts() {
  print_header "Installing Nerd Fonts..."
  yay -S --noconfirm --needed ttf-mononoki-nerd ttf-ubuntu-mono-nerd
}

# Install and configure Oh My Zsh
install_ohmyzsh() {
  if [[ "${PKG_SELECTED[zsh]}" != "1" ]]; then
    return
  fi

  print_header "Setting up Oh My Zsh..."

  if [ ! -d "$HOME/.oh-my-zsh" ]; then
    RUNZSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  else
    print_success "Oh My Zsh is already installed."
  fi

  local zsh_custom="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

  if [ ! -d "$zsh_custom/plugins/zsh-syntax-highlighting" ]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$zsh_custom/plugins/zsh-syntax-highlighting"
  fi

  if [ ! -d "$zsh_custom/plugins/zsh-autosuggestions" ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions "$zsh_custom/plugins/zsh-autosuggestions"
  fi

  # Set zsh as default shell
  if [[ "$SHELL" != *"zsh"* ]]; then
    print_header "Setting zsh as default shell..."
    chsh -s "$(which zsh)"
  fi
}

# Clone dotfiles repo if not present
clone_dotfiles() {
  if [ -d "$DOTFILES_DIR" ]; then
    print_success "Dotfiles directory already exists at $DOTFILES_DIR"
    return
  fi
  print_header "Cloning dotfiles..."
  git clone "$DOTFILES_REPO" "$DOTFILES_DIR"
}

# Apply dotfiles with stow
apply_stow() {
  local stow_dirs
  stow_dirs=$(collect_stow_dirs)

  if [[ -z "$stow_dirs" ]]; then
    print_warning "No packages selected, skipping stow."
    return
  fi

  print_header "Applying dotfiles with stow..."
  cd "$DOTFILES_DIR"

  for dir in $stow_dirs; do
    if [ -d "$dir" ]; then
      printf "  Linking %-20s" "$dir..."
      if stow -v -t "$HOME" "$dir" 2>/dev/null; then
        print_success "done"
      else
        print_warning "conflict (files may already exist, remove them first)"
      fi
    else
      print_warning "  Skipping $dir (directory not found)"
    fi
  done
}

# Main installation flow
main() {
  check_arch

  select_packages

  local pacman_pkgs
  pacman_pkgs=$(collect_packages)

  clear
  print_header "Starting installation..."

  # Base packages always needed
  print_header "Installing base packages..."
  sudo pacman -Syu --noconfirm
  sudo pacman -S --noconfirm --needed git curl stow base-devel lsd bat tmux $pacman_pkgs

  install_yay
  install_fonts
  clone_dotfiles
  install_ohmyzsh
  apply_stow

  printf "\n"
  printf " ─────────────────────────────────────\n"
  print_success " Installation complete!"
  print_warning " Log out and back in for all changes to take effect."
  printf " ─────────────────────────────────────\n\n"
}

main "$@"
