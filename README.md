# byte4cat's Dotfiles

![https://img.shields.io/static/v1?label=made%20with&message=love&color=red](https://img.shields.io/static/v1?label=made%20with&message=love&color=red)
![https://img.shields.io/static/v1?label=license&message=MIT&color=blue](https://img.shields.io/static/v1?label=license&message=MIT&color=blue)

This repository contains my personal configuration files (dotfiles) and a powerful installation script to automate the setup of a new development machine from scratch. The script is designed to be idempotent, meaning it can be run multiple times without causing issues.

---

## Features

- **Automated Installation**: A single command sets up a complete environment.
- **Cross-Platform Support**: Tailored setup for **macOS**, and **Arch Linux**.
- **Clean Symlinking**: Uses `stow` to manage symbolic links cleanly, keeping the home directory tidy.
- **Package Management**: Installs essential CLI tools, GUI applications, and Nerd Fonts via Homebrew, Pacman/yay, and DNF.
- **Self-Contained**: The installation script automatically clones this repository to the correct location.

---

## Installation

The installation is handled by a single script. You can run it directly from the terminal using `curl`.

### Quick Install (Recommended)

This is the simplest way to get started. It will clone the repository to the default location (`~/.dotfiles`) and begin the setup process.

Just copy and paste this command into your terminal:

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/byte4cat/dotfiles/main/install.sh)"
```

---

## Post-Installation Steps

After the script finishes, a few manual steps might be required:

1.  **Restart Your Terminal**: For all changes (especially `zsh` and shell aliases) to take effect.
2.  **Re-login for Docker**: On Linux, you need to log out and log back in for the Docker group permissions to apply.
3.  **Install Tmux Plugins**: Open `tmux` and press `prefix` + `I` (capital I) to fetch the plugins defined in `tmux.conf`.

---

## Customization

You can easily customize what gets installed by editing the `install.sh` script:

-   Open `install.sh` in your favorite editor.
-   Add or remove packages from the corresponding package list arrays (e.g., `brew_packages`, `pacman_packages`, `aur_packages`).

---

## Structure

The configuration files are managed by `stow` from the `stow/` directory.

`stow` creates symbolic links from these directories directly to your home directory (`~`).

