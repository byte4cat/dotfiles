# Environment Variables
export EDITOR="nvim"
export PATH="$HOME/.local/bin:$PATH"
export GPG_TTY=$(tty)
export DOTFILES_DIR="$HOME/dotfiles"

# Runtimes
# Go
export GOPATH="$HOME/go"
export PATH="$PATH:$GOPATH/bin"
# Rust
export PATH="$HOME/.cargo/bin:$PATH"
# Node
eval "$(fnm env --use-on-cd --shell zsh)"
# Bun & Flutter
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$HOME/flutter/bin:$HOME/.pub-cache/bin:$PATH"

if [[ "$(uname)" == "Darwin" ]]; then
    [ -f "$HOME/.zshrc_macos" ] && source "$HOME/.zshrc_macos"
elif [[ "$(uname)" == "Linux" ]]; then
    [ -f "$HOME/.zshrc_linux" ] && source "$HOME/.zshrc_linux"
fi

if [ -f "$HOME/.local/private/.zshrc_local" ]; then
    source "$HOME/.local/private/.zshrc_local"
fi

# Completion Initial
autoload -Uz compinit && compinit

if [ -f /usr/share/zsh/plugins/fzf-tab/fzf-tab.zsh ]; then
    source /usr/share/zsh/plugins/fzf-tab/fzf-tab.zsh
fi


[ -f /usr/share/zsh/key-bindings.zsh ] && source /usr/share/fzf/key-bindings.zsh
[ -f /usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh ] && source /usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh

# fzf 整合 (Ctrl+R, Alt+C 等快捷鍵)
[ -f /usr/share/fzf/key-bindings.zsh ] && source /usr/share/fzf/key-bindings.zsh
[ -f /usr/share/fzf/completion.zsh ] && source /usr/share/fzf/completion.zsh

# Plugins (Arch Native)
# make sure, sudo pacman -S zsh-autosuggestions zsh-syntax-highlighting fzf
[ -f /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ] && source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
[ -f /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ] && source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# fzf-tab 視覺優化
# 讓選單顏色跟著 LS_COLORS 走
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':fzf-tab:*' list-colors ${(s.:.)LS_COLORS}
# 切換目錄時顯示預覽 (使用 eza)
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --icons --color=always $realpath'
# kill 進程時顯示詳細資訊
zstyle ':fzf-tab:complete:kill:argument-rest' fzf-preview 'ps --pid=$word -o cmd --no-headers'

export FZF_DEFAULT_COMMAND='fd --type f --strip-cwd-prefix --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# History
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt hist_ignore_dups hist_ignore_space extended_history append_history inc_append_history share_history

# Vi Mode
bindkey -v
export KEYTIMEOUT=1 # 讓 Esc 切換模式更快，不會有延遲感

function vi-jk-escape() {
    read -t 0.15 -k 1 next
    if [[ $next == "k" ]]; then
        zle vi-cmd-mode
    else
        LBUFFER+="j$next"
    fi
}
zle -N vi-jk-escape
bindkey -M viins 'j' vi-jk-escape

bindkey -M viins '^A' beginning-of-line
bindkey -M viins '^E' end-of-line
bindkey -M viins '^W' backward-kill-word
bindkey -M viins '^U' backward-kill-line

# 快速搜尋歷史記錄 (輸入 gacp 按上，會只顯示 gacp 的歷史)
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
# 如果是 Vi Mode，這也很有用
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down


# Zoxide (replace cd)
eval "$(zoxide init zsh)"

# Starship & Theme
eval "$(starship init zsh)"

# Functions & Aliases
yy() {
    local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
    yazi "$@" --cwd-file="$tmp"
    if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
        cd -- "$cwd"
    fi
    rm -f -- "$tmp"
}

gacp() {
    git add -A && git commit -m "${1?'Missing commit message'}" && git push
}


alias ls='eza --icons --group-directories-first'
alias ll='eza -la --icons --git --group-directories-first'
alias vim="nvim"
alias vi="vim"
alias zz='yazi'
alias tcs='byte4work-tmux-choose-session'
alias tss='byte4work-tmux-sessionizer'

# bun completions
[ -s "/home/neil/.bun/_bun" ] && source "/home/neil/.bun/_bun"
