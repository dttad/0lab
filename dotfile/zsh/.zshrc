# ─── Oh My Zsh ────────────────────────────────────────────────────────────────
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="agnoster"

# Auto-update silently every 7 days
zstyle ':omz:update' mode auto
zstyle ':omz:update' frequency 7

plugins=(
  git
  docker
  docker-compose
  zsh-autosuggestions
  zsh-syntax-highlighting
  zsh-history-substring-search
  fzf
  sudo
  copypath
  dirhistory
  extract
  jsontools
)

# ─── History ──────────────────────────────────────────────────────────────────
HISTSIZE=50000
SAVEHIST=50000
HISTFILE=~/.zsh_history
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_VERIFY
setopt SHARE_HISTORY
setopt INC_APPEND_HISTORY

# ─── Navigation ───────────────────────────────────────────────────────────────
setopt AUTO_CD
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS
DIRSTACKSIZE=20

# ─── Completion ───────────────────────────────────────────────────────────────
setopt MENU_COMPLETE
setopt COMPLETE_IN_WORD
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*:descriptions' format '%F{yellow}-- %d --%f'

# ─── Path ─────────────────────────────────────────────────────────────────────
export PATH="$HOME/.local/bin:$HOME/bin:/usr/local/bin:$PATH"

# pyenv
if [[ -d "$HOME/.pyenv/bin" ]]; then
  export PYENV_ROOT="$HOME/.pyenv"
  export PATH="$PYENV_ROOT/bin:$PATH"
  eval "$(pyenv init -)"
fi

# ─── Editor ───────────────────────────────────────────────────────────────────
export EDITOR="vim"
export VISUAL="vim"

# ─── FZF ──────────────────────────────────────────────────────────────────────
export FZF_DEFAULT_OPTS="
  --height=40%
  --layout=reverse
  --border=rounded
  --info=inline
  --color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8
  --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc
  --color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8"
export FZF_CTRL_R_OPTS="--preview 'echo {}' --preview-window=down:3:wrap"

if command -v batcat >/dev/null 2>&1; then
  export FZF_CTRL_T_OPTS="--preview 'batcat --color=always --line-range :50 {}'"
elif command -v bat >/dev/null 2>&1; then
  export FZF_CTRL_T_OPTS="--preview 'bat --color=always --line-range :50 {}'"
fi

# ─── Autosuggestions ──────────────────────────────────────────────────────────
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#585b70"
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20

# ─── History substring search (Up/Down arrows) ────────────────────────────────
HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND="bg=#313244,fg=#a6e3a1,bold"
HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND="bg=#313244,fg=#f38ba8,bold"

if [[ -r "$ZSH/oh-my-zsh.sh" ]]; then
  source "$ZSH/oh-my-zsh.sh"
fi

bindkey '^ ' autosuggest-accept
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# ─── Aliases: navigation ──────────────────────────────────────────────────────
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias ~='cd ~'

# ─── Aliases: eza (modern ls) ─────────────────────────────────────────────────
if command -v eza >/dev/null 2>&1; then
  alias ls='eza --icons --group-directories-first'
  alias ll='eza -la --icons --group-directories-first --git'
  alias lt='eza --tree --icons --level=2'
  alias llt='eza --tree --icons --level=3 -la'
fi

# ─── Aliases: bat (modern cat) ────────────────────────────────────────────────
if command -v batcat >/dev/null 2>&1; then
  alias cat='batcat --paging=never'
  alias bat='batcat'
elif command -v bat >/dev/null 2>&1; then
  alias cat='bat --paging=never'
fi

# ─── Aliases: docker ──────────────────────────────────────────────────────────
alias dc='docker compose'
alias dcu='docker compose up -d'
alias dcd='docker compose down'
alias dcl='docker compose logs -f'
alias dps='docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"'
alias dex='docker exec -it'

# ─── Aliases: git ─────────────────────────────────────────────────────────────
alias g='git'
alias gs='git status -sb'
alias gl='git log --oneline --graph --decorate -20'
alias gp='git pull'
alias gP='git push'

# ─── Aliases: system ──────────────────────────────────────────────────────────
alias grep='grep --color=auto'
alias df='df -h'
alias du='du -sh'
alias free='free -h'
alias ports='ss -tlnp'
alias myip='curl -s ifconfig.me'
alias reload='source ~/.zshrc'
alias zshrc='$EDITOR ~/.zshrc'
alias tmuxconf='$EDITOR ~/.tmux.conf'

# ─── Functions ────────────────────────────────────────────────────────────────
cl() { cd "$1" && ls; }

mkcd() { mkdir -p "$1" && cd "$1"; }

fcd() {
  local dir
  dir=$(find "${1:-.}" -type d 2>/dev/null | fzf +m) && cd "$dir"
}

fzgrep() {
  local preview_cmd
  if command -v batcat >/dev/null 2>&1; then
    preview_cmd="batcat --color=always"
  elif command -v bat >/dev/null 2>&1; then
    preview_cmd="bat --color=always"
  else
    preview_cmd="cat"
  fi

  grep -rl "$1" . 2>/dev/null \
    | fzf --preview "${preview_cmd} {} | grep -n '$1'" \
    | xargs -r "$EDITOR"
}

dsh() {
  local ctr
  ctr=$(docker ps --format '{{.Names}}' | fzf) && docker exec -it "$ctr" sh
}

# ─── Local overrides ──────────────────────────────────────────────────────────
if [[ -r "$HOME/.zshrc.local" ]]; then
  source "$HOME/.zshrc.local"
fi
