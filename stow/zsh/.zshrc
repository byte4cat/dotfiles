if [[ "$(uname)" == "Darwin" ]]; then
    [ -f "$HOME/.zshrc_macos" ] && source "$HOME/.zshrc_macos"
elif [[ "$(uname)" == "Linux" ]]; then
    [ -f "$HOME/.zshrc_linux" ] && source "$HOME/.zshrc_linux"
fi

if [ -f "$HOME/.config/private/zsh/.zshrc_local" ]; then
    source "$HOME/.config/private/zsh/.zshrc_local"
fi


export ZPLUG_HOME=$HOME/.zplug


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
    #     export _JAVA_AWT_WM_NONREPARENTING="1" # Java applications fix
    # fi

fi

if [ "$XDG_SESSION_TYPE" = "x11" ]; then
    # --- X11 專用環境變量範例 ---

    # 解決某些舊版 GTK 應用程式在 X11 縮放上的問題 (如果縮放係數是 2)
    # export GDK_SCALE=2

    # 針對 X11 上的 Electron 應用程式 (如果 Wayland 模式不適用，確保它使用 X11)
    # export ELECTRON_FORCE_WAYLAND=0

    # 針對某些 Java 應用程式的修復 (較舊的 X11 設置可能需要)
    # export _JAVA_AWT_WM_NONREPARENTING=1

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

# --- Zsh 模式與按鍵綁定 ---
bindkey -v # 啟用 vi 模式

# vi 模式下，使用 jk 快速退回到 Normal Mode
function vi-jk-escape() {
  # 讀取下一個按鍵，設定短超時
  read -t 0.15 -k 1 next
  if [[ $next == "k" ]]; then
    zle vi-cmd-mode
  else
    LBUFFER+="j$next"
  fi
}
zle -N vi-jk-escape
bindkey -M viins 'j' vi-jk-escape

# --- 基本環境變數 ---
export TERM="xterm-256color"
export EDITOR="nvim"
export KITTY_SOCK_DIR=/tmp/kitty

# --- zplug 插件管理器 ---
# 載入 zplug (路徑應在 OS 特定檔案中設定)
if [ -n "$ZPLUG_HOME" ] && [ -f "$ZPLUG_HOME/init.zsh" ]; then
    source $ZPLUG_HOME/init.zsh
else
    echo "警告: ZPLUG_HOME 未設定或 zplug init.zsh 不存在。"
fi

# 主題 (powerlevel10k)
zplug romkatv/powerlevel10k, as:theme
[[ ! -f $HOME/.p10k.zsh ]] || source $HOME/.p10k.zsh

# zplug 自我管理
zplug 'zplug/zplug', hook-build:'zplug --self-manage'

# 通用插件
zplug "zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-completions"
zplug "zsh-users/zsh-history-substring-search", defer:2
zplug "plugins/git", from:oh-my-zsh, defer:3
zplug "modules/prompt", from:prezto, defer:3
zplug "zsh-users/zsh-syntax-highlighting", defer:2
zplug "Aloxaf/fzf-tab"
zplug "paulirish/git-open", as:plugin

# macOS 特有插件 (zplug 的 if 判斷可以讓它留在通用設定中)
if [[ "$(uname)" == "Darwin" ]]; then
    zplug "lib/clipboard", from:oh-my-zsh, defer:2, if:"[[ $OSTYPE == *darwin* ]]"
fi


# 檢查並安裝插件
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

# 載入所有插件
zplug load

# --- Powerlevel10k 即時提示 ---
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# --- PATH 基本設定 (通用部分) ---
export PATH=$HOME/bin:/usr/local/bin:$PATH

# --- 自訂函式 ---
gacp() {
    git add -A &&
    git commit -m "${1?'Missing commit message'}" &&
    git push
}

cover () {
    t="/tmp/go-cover.$$.tmp"
    go test -coverprofile=$t $@ && go tool cover -html=$t && unlink $t
}

yy() {
    local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
    yazi "$@" --cwd-file="$tmp"
    if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
        cd -- "$cwd"
    fi
    rm -f -- "$tmp"
}

# --- 通用別名 ---
alias c="clear"
alias ll="ls -lA"
alias la="ls -a"
alias k="kubectl"
alias vim="nvim"
alias fp="lsof -i"
alias yd="youtubedr"
alias t="tmux"
alias ts='$HOME/.local/bin/tmux-sessionizer.sh'
alias tc='$HOME/.local/bin/tmux-choose-session.sh'
alias zz='yazi'

# --- 跨平台開發工具 ---
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

# Flutter & Flutterfire CLI
export PATH="$PATH:$HOME/flutter/bin"
export PATH="$PATH:$HOME/.pub-cache/bin"

# Bun
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# Rust
. "$HOME/.cargo/env"

# Google Cloud SDK
if [ -f "$HOME/google-cloud-sdk/path.zsh.inc" ]; then
    . "$HOME/google-cloud-sdk/path.zsh.inc"
fi
if [ -f "$HOME/google-cloud-sdk/completion.zsh.inc" ]; then
    . "$HOME/google-cloud-sdk/completion.zsh.inc"
fi

# zoxide and z (zoxide 優先)
eval "$(zoxide init zsh)"
alias cd="z"

# Docker CLI 補全
if [ -d "$HOME/.docker/completions" ]; then
    fpath=($HOME/.docker/completions $fpath)
fi
# 確保 compinit 只被初始化一次
if ! (( $+functions[compinit] )); then
    autoload -Uz compinit
fi


# AsyncAPI CLI Autocomplete

ASYNCAPI_AC_ZSH_SETUP_PATH=/home/neil/.cache/@asyncapi/cli/autocomplete/zsh_setup && test -f $ASYNCAPI_AC_ZSH_SETUP_PATH && source $ASYNCAPI_AC_ZSH_SETUP_PATH; # asyncapi autocomplete setup
