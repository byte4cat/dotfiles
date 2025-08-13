#!/bin/bash
# ==============================================================================
# Dotfiles Installation and Setup Script (Stow Version)
#
# Author: byte4cat
# Date: 2025-07-13 15:58:48 UTC
#
# This script will:
# 1. Check for core dependencies (git, stow).
# 2. Use Stow to create symbolic links for configuration files.
# 3. Install corresponding packages based on the operating system (macOS or Linux).
#
# Usage: Run ./install.sh from the dotfiles root directory.
# ==============================================================================

# Exit immediately if a command exits with a non-zero status.
set -euo pipefail

# --- Color Definitions ---
Green='\033[0;32m'
Red='\033[0;31m'
Blue='\033[1;34m'
Yellow='\033[0;33m'
Reset='\033[0m'

# --- Helper Functions ---
info() {
    echo -e "${Blue}[INFO] ${1}${Reset}"
}

success() {
    echo -e "${Green}${1}${Reset}"
}

warn() {
    echo -e "${Yellow}[WARN] ${1}${Reset}"
}

error() {
    echo -e "${Red}[ERROR] ${1}${Reset}" >&2
    exit 1
}

# Set the destination for the dotfiles repository.
# It respects a user-defined $DOTFILES_DIR, otherwise defaults to $HOME/.dotfiles.
# The `export` command makes this variable available to subsequent processes.
export DOTFILES_DIR="$HOME/dotfiles"

# 1. Bootstrap function to clone the repository
bootstrap() {
    info "Starting bootstrap process..."
    info "Dotfiles will be cloned to: ${DOTFILES_DIR}"

    if ! command -v git &>/dev/null; then
        error "'git' is required for bootstrapping. Please install it first."
    fi

    if [ -d "$DOTFILES_DIR" ]; then
        success "Dotfiles directory already exists at $DOTFILES_DIR."
    else
        info "Cloning dotfiles repository to $DOTFILES_DIR..."
        git clone -q --depth=1 "https://github.com/byte4cat/dotfiles.git" "$DOTFILES_DIR"
        success "Repository cloned successfully."
    fi

    # Change into the dotfiles directory to run the rest of the script
    cd "$DOTFILES_DIR"
}

# 2. Check for core dependencies.
check_dependencies() {
    info "Checking for core dependencies..."
    local missing_deps=0
    for cmd in git stow; do
        if ! command -v "$cmd" &>/dev/null; then
            warn "$cmd is not installed."
            missing_deps=1
        fi
    done

    if [ $missing_deps -ne 0 ]; then
        error "Please install the missing dependencies and run the script again."
    else
        success "All core dependencies are installed."
    fi
}

# --- Main Functions ---

# Create Symbolic Links with Stow
stow_dotfiles() {
    info "Stowing all dotfiles packages..."
    if [ ! -d "stow" ]; then
        error "'stow' directory not found. Make sure you are in the dotfiles root."
    fi

    local macos_only=(yabai skhd sketchybar borders)
    local linux_only=(fcitx5 waybar wofi hyprland tofi dunst)

    local os="$(uname)"
    for pkg in stow/*; do
        [ -d "$pkg" ] || continue
        pkg_name=$(basename "$pkg")

        if [[ "$os" != "Darwin" ]] && [[ " ${macos_only[*]} " == *" $pkg_name "* ]]; then
            warn "Skipping $pkg_name (macOS only)"
            continue
        fi
        if [[ "$os" != "Linux" ]] && [[ " ${linux_only[*]} " == *" $pkg_name "* ]]; then
            warn "Skipping $pkg_name (Linux only)"
            continue
        fi

        info "Stowing package: $pkg_name"
        stow -d stow -t "$HOME" --restow "$pkg_name"
    done

    if [ -d "private" ]; then
        mkdir -p "$HOME/.config/private"
        info "Stowing private configs..."
        stow -v -d . -t "$HOME/.config/private" --restow private
    fi

    success "Symbolic links created successfully."
}

# --- Install Tmux Plugin Manager (TPM) ---
install_tmux_plugins() {
    info "Checking and installing Tmux Plugin Manager (TPM)..."
    local tpm_dir="$HOME/.tmux_plugins/tpm"

    if [ ! -d "$tpm_dir" ]; then
        info "TPM not found. Cloning from GitHub..."
        git clone -q --depth=1 https://github.com/tmux-plugins/tpm "$tpm_dir"
        success "TPM installed successfully."
    else
        warn "TPM is already installed, skipping."
    fi
}

# macOS Installation Flow
install_macos() {
    info "Starting macOS installation process..."

    # Ask the user if they want to proceed with the installation
    read -rp "This script will install packages on your macOS system. Do you want
    to continue? (y/n): " confirm

    if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
        warn "Installation aborted by user."
        exit 0
    fi

    # Install Homebrew
    if ! command -v brew &>/dev/null; then
        warn "Homebrew not found. Installing automatically..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    else
        success "Homebrew is already installed."
    fi

    # Update Homebrew
    info "Updating Homebrew..."
    brew update

    # Install packages
    info "Installing Homebrew packages..."
    brew_packages=(
        "stow" "zsh" "tmux" "neovim" "git" "wget"
        "koekeishiya/formulae/yabai" "koekeishiya/formulae/skhd" "felixkratz/formulae/sketchybar"
        "fastfetch" "bat" "ripgrep" "fd" "fzf" "jq" "htop" "btop" "tree" "nmap"
        "go" "unzip" "ffmpeg" "zplug" "yazi"
    )

    brew_cask_packages=(
        "alacritty" "kitty" "ghostty" "obsidian"
        "font-hack-nerd-font" "font-meslo-lg-nerd-font"
    )

    # Install CLI tools
    for package in "${brew_packages[@]}"; do
        if ! brew list "$package" &>/dev/null; then
            info "Installing $package..."
            brew install "$package"
        else
            warn "$package is already installed, skipping."
        fi
    done

    # Install GUI applications
    for package in "${brew_cask_packages[@]}"; do
        if ! brew list --cask "$package" &>/dev/null; then
            info "Installing $package (cask)..."
            brew install --cask "$package"
        else
            warn "$package (cask) is already installed, skipping."
        fi
    done

    # Start Yabai and skhd services
    info "Starting yabai and skhd services..."
    yabai --start-service
    skhd --start-service

    success "macOS installation process completed!"
}

# Linux Installation Flow (Arch Linux)
install_linux_arch() {
    info "Starting Arch Linux installation process..."

    # Ask the user if they want to proceed with the installation
    read -rp "This script will install packages on your Arch Linux system. Do you want
    to continue? (y/n): " confirm

    if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
        warn "Installation aborted by user."
        exit 0
    fi

    # --- Package Lists ---
    # Add your desired packages here
    local pacman_packages=(
        "zsh" "tmux" "neovim" "git" "wget" "docker"
        "fcitx5-im" "fcitx5-chewing" # Input Method
        "bat" "ripgrep" "fd" "fzf" "jq" "htop" "btop" "tree" "nmap"
        "go" "unzip" "ffmpeg"
    )

    local aur_packages=(
        "fastfetch" "yazi" "hyprshot"
    )

    # --- AUR Helper (yay) Installation ---
    if ! command -v yay &>/dev/null; then
        warn "AUR helper 'yay' not found. Attempting to install..."
        info "This requires 'base-devel' and 'git' to be installed."
        sudo pacman -S --noconfirm --needed base-devel git

        local yay_dir="/tmp/yay-install"
        info "Cloning yay from AUR to $yay_dir..."
        git clone https://aur.archlinux.org/yay.git "$yay_dir"

        info "Building and installing yay from $yay_dir..."
        (cd "$yay_dir" && makepkg -si --noconfirm)

        info "Cleaning up $yay_dir..."
        rm -rf "$yay_dir"

        if ! command -v yay &>/dev/null; then
            error "Failed to install yay. Please install it manually and re-run."
        fi
        success "AUR helper 'yay' installed successfully."
    else
        success "AUR helper 'yay' is already installed."
    fi

    # --- Pacman Package Installation ---
    info "Updating pacman database and installing packages..."
    sudo pacman -Syu --noconfirm
    for package in "${pacman_packages[@]}"; do
        if ! pacman -Q "$package" &>/dev/null; then
            info "Installing (pacman): $package..."
            sudo pacman -S --noconfirm --needed "$package"
        else
            warn "(pacman) $package is already installed, skipping."
        fi
    done

    # --- AUR Package Installation ---
    info "Installing AUR packages with yay..."
    for package in "${aur_packages[@]}"; do
        if ! yay -Q "$package" &>/dev/null; then
            info "Installing (AUR): $package..."
            yay -S --noconfirm --needed "$package"
        else
            warn "(AUR) $package is already installed, skipping."
        fi
    done

    # --- Post-installation Steps ---
    info "Performing post-installation steps..."

    # Hyprshot screenshot directory
    mkdir -p "$HOME/Screenshots"
    success "Created screenshot directory at ~/Screenshots."

    # Docker service
    info "Enabling and starting Docker service..."
    sudo systemctl enable --now docker.service
    sudo usermod -aG docker "$USER"
    warn "You need to log out and log back in for Docker permissions to take effect."

    # Fcitx5 input method configuration
    info "Updating GTK icon cache for Fcitx5..."
    sudo gtk-update-icon-cache /usr/share/icons/hicolor
    warn "Please restart Fcitx5 to see input method changes."

    success "Arch Linux installation process completed!"
}

# --- Main Program ---
main() {
    bootstrap

    info "Starting dotfiles setup..."

    check_dependencies
    stow_dotfiles

    # Run OS-specific installation flow
    if [[ "$(uname)" == "Darwin" ]]; then
        install_macos
        install_tmux_plugins
    elif [[ "$(uname)" == "Linux" ]]; then
        # Check for Arch Linux specifically
        if [[ -f /etc/arch-release ]] || grep -q "Arch Linux" /etc/os-release 2>/dev/null; then
            install_linux_arch
            install_tmux_plugins
        else
            warn "Unsupported Linux distribution. Skipping specific package installation."
        fi
    else
        warn "Unsupported operating system: $(uname)"
    fi

    success "🎉 Dotfiles setup complete! 🎉"
    warn "Please restart your terminal or reload its configuration (e.g., 'source ~/.zshrc') for changes to take effect."
}

# Execute the main function
main
