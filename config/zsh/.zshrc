# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

if [[ "$(uname)" == "Darwin" ]]; then
    [ -f "$HOME/.zshrc_macos" ] && source "$HOME/.zshrc_macos"
elif [[ "$(uname)" == "Linux" ]]; then
    [ -f "$HOME/.zshrc_linux" ] && source "$HOME/.zshrc_linux"
fi

if [ -f "$HOME/.local/private/zsh/.zshrc_local" ]; then
    source "$HOME/.local/private/zsh/.zshrc_local"
fi

# --- Basic Environment Variables ---
export ZPLUG_HOME=$HOME/.zplug
export EDITOR="nvim"
export KITTY_SOCK_DIR=/tmp/kitty
export PATH="$HOME/.local/bin:$PATH"

# Check if the session is running under Wayland
if [ -n "$WAYLAND_DISPLAY" ]; then
    # --- Standard Wayland Integration ---
    # Ensure standard libraries (GTK, Qt, Firefox) use the native Wayland backend
    export GDK_BACKEND="wayland"
    export QT_QPA_PLATFORM="wayland"
    export MOZ_ENABLE_WAYLAND="1"

    # --- Electron/Chromium Fixes (Vesktop) ---
    # Tell Electron apps to use the native Wayland backend
    export ELECTRON_OZONE_PLATFORM_HINT="wayland"

    # FIX: Use this if you experience screen tearing or graphical corruption
    # This disables GPU acceleration and forces software rendering, often necessary for Electron on Hyprland.
    # export ELECTRON_DISABLE_GPU="false"

    # FIX: Use this if you are running a Flatpak application and experience issues
    # export FLATPAK_ENABLE_GPU_SANDBOX="0"

    # --- Other Wayland Compositors (optional) ---
    # Use this if you need to detect Hyprland specifically
    # if [ "$XDG_CURRENT_DESKTOP" = "Hyprland" ]; then
    # 	export _JAVA_AWT_WM_NONREPARENTING="1" # Java applications fix
    # fi

    # My scripts locations
    export PATH="$HOME/.local/bin/wayland:$PATH"
    export PATH="$HOME/.local/private/bin:$PATH"
fi

if [ "$XDG_SESSION_TYPE" = "x11" ]; then
    # My scripts locations
    export PATH="$HOME/.local/bin/x11:$PATH"
    export PATH="$HOME/.local/private/bin:$PATH"

fi

# Zsh history settings
# history file location
HISTFILE=~/.zsh_history
# set history size
HISTSIZE=10000
SAVEHIST=10000
# ignore duplicate commands
setopt hist_ignore_dups
# ignore commands that start with space
setopt hist_ignore_space
# store multi-line commands as single history entry
setopt extended_history
# append to the history file, don't overwrite it
setopt append_history
# immediately append history changes to the history file
setopt inc_append_history
# share history across all sessions
setopt share_history

# --- Zsh Mode and Key Bindings ---
bindkey -v # Enable vi mode

# In vi-insert mode, use 'jk' to quickly switch back to Normal Mode
function vi-jk-escape() {
    # Read the next key with a short timeout
    read -t 0.15 -k 1 next
    if [[ $next == "k" ]]; then
        zle vi-cmd-mode
    else
        # If the next key is not 'k', append 'j' and the next key to the buffer
        LBUFFER+="j$next"
    fi
}
zle -N vi-jk-escape
bindkey -M viins 'j' vi-jk-escape


# --- zplug Plugin Manager ---
# Load zplug (path should be set in OS-specific files)
if [ -n "$ZPLUG_HOME" ] && [ -f "$ZPLUG_HOME/init.zsh" ]; then
    source $ZPLUG_HOME/init.zsh
else
    echo "Warning: ZPLUG_HOME is not set or zplug init.zsh does not exist."
fi

# Theme (powerlevel10k)
zplug romkatv/powerlevel10k, as:theme
[[ ! -f $HOME/.p10k.zsh ]] || source $HOME/.p10k.zsh

# zplug self-management
zplug 'zplug/zplug', hook-build:'zplug --self-manage'

# General Plugins
zplug "zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-completions"
zplug "zsh-users/zsh-history-substring-search", defer:2
zplug "plugins/git", from:oh-my-zsh, defer:3
zplug "modules/prompt", from:prezto, defer:3
zplug "zsh-users/zsh-syntax-highlighting", defer:2
zplug "Aloxaf/fzf-tab"
zplug "paulirish/git-open", as:plugin

# macOS Specific Plugin (zplug's 'if' condition keeps this general)
if [[ "$(uname)" == "Darwin" ]]; then
    zplug "lib/clipboard", from:oh-my-zsh, defer:2, if:"[[ $OSTYPE == *darwin* ]]"
fi


# Check and Install Plugins
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

# Load all plugins
zplug load

# --- Powerlevel10k Instant Prompt ---
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# --- Basic PATH Settings (General) ---
export PATH=$HOME/bin:/usr/local/bin:$PATH

# --- Custom Functions ---
# gacp: Git Add, Commit, and Push
gacp() {
    git add -A &&
    git commit -m "${1?'Missing commit message'}" &&
    git push
}

# cover: Run Go tests with coverage and open in browser
cover () {
    t="/tmp/go-cover.$$.tmp"
    go test -coverprofile=$t $@ && go tool cover -html=$t && unlink $t
}

# yy: yazi file manager integration (cd into selected directory)
yy() {
    local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
    yazi "$@" --cwd-file="$tmp"
    if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
        cd -- "$cwd"
    fi
    rm -f -- "$tmp"
}

# --- General Aliases ---
# alias ll="ls -la"
# alias la="ls -a"
alias ls='eza --icons --group-directories-first'
alias ll='eza -la --icons --git --group-directories-first --links --color-scale'
alias lt='eza --tree --level=2 --icons'
alias k="kubectl"
alias vim="nvim"
alias fp="lsof -i"
alias yd="youtubedr"
alias ts='byte4work-tmux-sessionizer'
alias tc='byte4work-tmux-choose-session'
alias zz='yazi'

# --- Cross-Platform Development Tools ---
# conda (miniforge)
__conda_setup="$('$HOME/miniforge3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "$HOME/miniforge3/etc/profile.d/conda.sh" ]; then
        . "$HOME/miniforge3/etc/profile.d/conda.sh"
    else
        export PATH="$HOME/miniforge3/bin:$PATH"
    fi
fi
unset __conda_setup

# NVM (Node Version Manager)
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# Golang
export GOPATH="$HOME/go"
export GOBIN="$GOPATH/bin"
export PATH="$PATH:$GOBIN"

# Rust
export PATH="$HOME/.cargo/bin:$PATH"

# Flutter & Flutterfire CLI
export PATH="$PATH:$HOME/flutter/bin"
export PATH="$PATH:$HOME/.pub-cache/bin"

# Bun
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# Google Cloud SDK
if [ -f "$HOME/google-cloud-sdk/path.zsh.inc" ]; then
    . "$HOME/google-cloud-sdk/path.zsh.inc"
fi
if [ -f "$HOME/google-cloud-sdk/completion.zsh.inc" ]; then
    . "$HOME/google-cloud-sdk/completion.zsh.inc"
fi

# zoxide and z (zoxide preferred)
eval "$(zoxide init zsh)"
alias cd="z"

# Docker CLI Completion
if [ -d "$HOME/.docker/completions" ]; then
    fpath=($HOME/.docker/completions $fpath)
fi
# Ensure compinit is initialized only once
if ! (( $+functions[compinit] )); then
    autoload -Uz compinit
fi

# AsyncAPI CLI Autocomplete
ASYNCAPI_AC_ZSH_SETUP_PATH=/home/neil/.cache/@asyncapi/cli/autocomplete/zsh_setup && test -f $ASYNCAPI_AC_ZSH_SETUP_PATH && source $ASYNCAPI_AC_ZSH_SETUP_PATH; # asyncapi autocomplete setup

# # Re-bind for Vi-Insert Mode
# # Use the correct ZLE widget names for Vi mode
# bindkey -M viins '^A' vi-beginning-of-line
# bindkey -M viins '^E' vi-end-of-line
# bindkey -M viins '^K' vi-kill-line
# bindkey -M viins '^U' backward-kill-line
# bindkey -M viins '^W' backward-kill-word
# bindkey -M viins '^F' vi-forward-char
# bindkey -M viins '^B' vi-backward-char
# bindkey -M viins '^L' clear-screen
# bindkey -M viins '^R' history-incremental-search-backward
#
# # Also allow movement in Command mode (optional)
# bindkey -M vicmd '^A' vi-beginning-of-line
# bindkey -M vicmd '^E' vi-end-of-line
# export PATH="$HOME/.local/share/nvim/mason/bin:$PATH"

export GPG_TTY=$(tty)
source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/home/neil/Downloads/google-cloud-sdk/path.zsh.inc' ]; then . '/home/neil/Downloads/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/home/neil/Downloads/google-cloud-sdk/completion.zsh.inc' ]; then . '/home/neil/Downloads/google-cloud-sdk/completion.zsh.inc'; fi
