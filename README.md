# yimincai's Dotfiles

![https://img.shields.io/static/v1?label=made%20with&message=love&color=red](https://img.shields.io/static/v1?label=made%20with&message=love&color=red)
![https://img.shields.io/static/v1?label=license&message=MIT&color=blue](https://img.shields.io/static/v1?label=license&message=MIT&color=blue)

This repository contains my personal configuration files (dotfiles) and a powerful installation script to automate the setup of a new development machine from scratch. The script is designed to be idempotent, meaning it can be run multiple times without causing issues.

---

## Features

- **Automated Installation**: A single command sets up a complete environment.
- **Cross-Platform Support**: Tailored setup for **macOS**, **Arch Linux**, and **Fedora**.
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
bash -c "$(curl -fsSL https://raw.githubusercontent.com/yimincai/dotfiles/main/install.sh)"
```

### Custom Directory Install (Advanced)

If you prefer to store the dotfiles repository in a custom location (for example, inside a dedicated development folder), you can do so by setting the `DOTFILES_DIR` environment variable **before** running the installation command.

**Step 1: Set your desired path**
Tell the script where you want to clone the repository. For example, to use `~/Development/personal/dotfiles`:

```bash
export DOTFILES_DIR="$HOME/Development/personal/dotfiles"
```

**Step 2: Run the installer**
Now, run the exact same installation command. The script will automatically detect the environment variable and clone the repository to the path you specified.

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/yimincai/dotfiles/main/install.sh)"
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
-   Navigate to the installation function for your OS (`install_macos`, `install_linux_arch`, or `install_linux_fedora`).
-   Add or remove packages from the corresponding package list arrays (e.g., `brew_packages`, `pacman_packages`, `aur_packages`, `dnf_packages`).

---

## Structure

The configuration files are managed by `stow` from the `stow/` directory.

-   `stow/common/`: Contains configurations that are shared across all operating systems (e.g., `zsh`, `tmux`, `nvim`).
-   `stow/macos/`: Contains configurations specific to macOS (e.g., `yabai`, `skhd`).
-   `stow/linux/`: Contains configurations specific to Linux. (e.g., `i3`, `sway`, `hyprland`, `wofi`).

`stow` creates symbolic links from these directories directly to your home directory (`~`).

