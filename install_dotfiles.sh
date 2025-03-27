#!/bin/bash

# Actualizar el sistema
sudo pacman -Syu --noconfirm

# Paquetes esenciales para dotfiles y escritorio
sudo pacman -S --noconfirm \
    git \
    curl \
    zsh \
    neovim \
    tmux \
    fzf \
    ripgrep \
    exa \
    bat \
    stow \
    base-devel \
    lsd \
    alacritty \
    acpi \
    bspwm \
    sxhkd \
    rofi \
    feh \
    polybar \
    network-manager-applet

# Instalar yay (si no está instalado)
if ! command -v yay &> /dev/null; then
  git clone https://aur.archlinux.org/yay.git
  cd yay
  makepkg -si --noconfirm
  cd ..
  rm -rf yay
fi

# Instalar paquetes del AUR
yay -S --noconfirm rofi-bluetooth-git nerd-fonts-mononoki nerd-fonts-ubuntu-mono

# Instalar Oh My Zsh (si no está instalado)
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# Clonar dotfiles (si no existen)
if [ ! -d "$HOME/.dotfiles" ]; then
  git clone https://github.com/ch3ber/dotfiles.git "$HOME/.dotfiles"
fi

# Clonar wallpapers (si no existen)
if [ ! -d "$HOME/wallpapers" ]; then
  git clone https://github.com/ch3ber/wallpapers.git "$HOME/wallpapers"
fi

# Copiar dotfiles al sistema (reemplazando archivos existentes)
cp -rf "$HOME/.dotfiles/." "$HOME/"

# Cambiar shell por defecto a Zsh
chsh -s $(which zsh)

# Finalización
printf "\n\e[32m¡Instalación y configuración completadas! Inicia sesión de nuevo para notar los cambios.\e[0m\n"
