if [[ "$(uname)" == "Darwin" ]]; then
    [ -f "${ZDOTDIR:-$HOME}/.zshrc_macos" ] && source "${ZDOTDIR:-$HOME}/.zshrc_macos"
elif [[ "$(uname)" == "Linux" ]]; then
    [ -f "${ZDOTDIR:-$HOME}/.zshrc_linux" ] && source "${ZDOTDIR:-$HOME}/.zshrc_linux"
fi

if [ -f "${ZDOTDIR:-$HOME}/.zshrc_local" ]; then
    source "${ZDOTDIR:-$HOME}/.zshrc_local"
fi

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

# macOS 特有插件 (zplug 的 if 判斷可以讓它留在通用設定中)
zplug "lib/clipboard", from:oh-my-zsh, defer:2, if:"[[ $OSTYPE == *darwin* ]]"

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
alias ts='$HOME/.config/scripts/tmux-sessionizer.sh'
alias tc='$HOME/.config/scripts/tmux-choose-session.sh'
alias vpn='$HOME/.config/scripts/vpn.sh'
alias zz='yazi'
alias ok='$HOME/.config/scripts/kitty_socket.sh'
# kitty wallpaper
alias bgs='$HOME/.config/scripts/kitty_set_bg.sh'
alias bgg='$HOME/.config/scripts/kitty_remove_bg.sh'

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
compinit
