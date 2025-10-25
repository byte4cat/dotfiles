# byte4cat's Dotfiles

![https://img.shields.io/static/v1?label=made%20with&message=love&color=red](https://img.shields.io/static/v1?label=made%20with&message=love&color=red)
![https://img.shields.io/static/v1?label=license&message=MIT&color=blue](https://img.shields.io/static/v1?label=license&message=MIT&color=blue)

This repository contains my personal configuration files (dotfiles) and a powerful, modular set of installation and synchronization scripts to automate the setup of a new development machine from scratch. The primary script is designed to be idempotent, meaning it can be run multiple times without causing issues.

---

## Features

- **Modular Automation**: Tasks are separated into specialized scripts (`install_arch_pkgs`, `sync_dotfiles`, `sync_pkgs`) and orchestrated by a single master script (`install`).
- **Clean Symlinking**: Uses `stow` to manage symbolic links cleanly from the `stow/` directory, keeping the home directory tidy.
- **Declarative Package Management**: Package lists (`pacman_list.txt`, `aur_list.txt`) are managed externally in the `requirements/` directory.
- **Package Syncing**: A dedicated script (`sync_pkgs`) allows you to automatically update your requirements lists from the current installed system.
- **Arch Linux Focus**: Optimized for Arch Linux and the `yay` AUR helper.
- **Self-Contained**: The repository structure follows a standard `bin/`, `lib/`, `requirements/` layout for high maintainability.

---

## Installation

The complete environment setup is handled by the master script, `path_to_repo/install`.

### Step 1: Clone the Repository

```bash
git clone https://github.com/byte4cat/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
```


### Step 2: Run the Master Setup Script

The `install` script will guide you through the process, prompting you to install packages and deploy configurations.

```bash
# Ensure the script has execution permission (it should, but good practice)
chmod +x ./install

# Run the full setup
./install
```

---

## Post-Installation Steps

After the script finishes, a few manual steps might be required:

1.  **Restart Your Terminal**: For all changes (especially `zsh` and shell aliases) to take effect.
2.  **Re-login for Docker**: On Linux, you need to log out and log back in for the Docker group permissions to apply.
3.  **Install Tmux Plugins**: Open `tmux` and press `prefix` + `I` (capital I) to fetch the plugins defined in `tmux.conf`.

---

## Customization

### Package Lists

The lists of packages to install are managed in separate files for simplicity:

- `requirements/pacman_list.txt`: Core packages installed via `pacman`.
- `requirements/aur_list.txt`: AUR packages installed via `yay`.

To add or remove packages, simply edit these two text files.

### Deployments

Configuration files for deployment are located in the `stow/` directory. Each subdirectory here is treated as a separate package by the deployment script.

---

## Structure

The configuration files are managed by `stow` from the `stow/` directory.

`stow` creates symbolic links from these directories directly to your home directory (`~`).

