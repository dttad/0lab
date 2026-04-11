#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
TIMESTAMP="$(date +%Y%m%d%H%M%S)"

TARGET_USER="${SUDO_USER:-$USER}"
TARGET_HOME="$(getent passwd "$TARGET_USER" | cut -d: -f6)"

if [[ -z "${TARGET_HOME}" ]]; then
  echo "Unable to resolve home directory for user: ${TARGET_USER}" >&2
  exit 1
fi

if [[ $EUID -eq 0 ]]; then
  SUDO=""
else
  SUDO="sudo"
fi

log() {
  printf '\n[%s] %s\n' "$(date '+%H:%M:%S')" "$*"
}

run_as_target() {
  if [[ "$(id -un)" == "${TARGET_USER}" ]]; then
    "$@"
  else
    sudo -u "${TARGET_USER}" "$@"
  fi
}

backup_file() {
  local destination="$1"

  if [[ -e "${destination}" && ! -L "${destination}" ]]; then
    cp -a "${destination}" "${destination}.bak.${TIMESTAMP}"
  fi
}

install_file() {
  local source="$1"
  local destination="$2"
  local mode="$3"

  mkdir -p "$(dirname "${destination}")"
  backup_file "${destination}"
  install -m "${mode}" "${source}" "${destination}"
  chown "${TARGET_USER}:${TARGET_USER}" "${destination}"
}

install_dir() {
  local path="$1"
  mkdir -p "${path}"
  chown "${TARGET_USER}:${TARGET_USER}" "${path}"
}

ensure_ubuntu_2404() {
  if [[ -r /etc/os-release ]]; then
    # shellcheck disable=SC1091
    . /etc/os-release
    if [[ "${ID:-}" != "ubuntu" || "${VERSION_ID:-}" != "24.04" ]]; then
      log "Warning: this script targets Ubuntu 24.04, current system is ${PRETTY_NAME:-unknown}."
    fi
  fi
}

install_packages() {
  log "Installing apt packages"
  ${SUDO} apt-get update
  DEBIAN_FRONTEND=noninteractive ${SUDO} apt-get install -y \
    bat \
    bc \
    build-essential \
    ca-certificates \
    curl \
    eza \
    fonts-powerline \
    fzf \
    git \
    locales \
    lm-sensors \
    tmux \
    vim \
    xclip \
    zsh
}

install_oh_my_zsh() {
  local ohmyzsh_dir="${TARGET_HOME}/.oh-my-zsh"
  local custom_dir="${ohmyzsh_dir}/custom/plugins"

  install_dir "${TARGET_HOME}/.config"

  if [[ ! -d "${ohmyzsh_dir}" ]]; then
    log "Cloning Oh My Zsh"
    run_as_target git clone --depth=1 https://github.com/ohmyzsh/ohmyzsh.git "${ohmyzsh_dir}"
  else
    log "Oh My Zsh already present"
  fi

  install_dir "${custom_dir}"

  if [[ ! -d "${custom_dir}/zsh-autosuggestions" ]]; then
    log "Installing zsh-autosuggestions"
    run_as_target git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions "${custom_dir}/zsh-autosuggestions"
  fi

  if [[ ! -d "${custom_dir}/zsh-syntax-highlighting" ]]; then
    log "Installing zsh-syntax-highlighting"
    run_as_target git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git "${custom_dir}/zsh-syntax-highlighting"
  fi
}

install_configs() {
  log "Installing zsh, tmux, and vim configs"

  install_dir "${TARGET_HOME}/.tmux/scripts"
  install_dir "${TARGET_HOME}/.vim"
  install_dir "${TARGET_HOME}/.vim/backup"
  install_dir "${TARGET_HOME}/.vim/swap"
  install_dir "${TARGET_HOME}/.vim/undo"

  install_file "${SCRIPT_DIR}/zsh/.zshrc" "${TARGET_HOME}/.zshrc" 0644
  install_file "${SCRIPT_DIR}/tmux/.tmux.conf" "${TARGET_HOME}/.tmux.conf" 0644
  install_file "${SCRIPT_DIR}/vim/.vimrc" "${TARGET_HOME}/.vimrc" 0644

  install_file "${SCRIPT_DIR}/tmux/scripts/cpubar.sh" "${TARGET_HOME}/.tmux/scripts/cpubar.sh" 0755
  install_file "${SCRIPT_DIR}/tmux/scripts/cputemp.sh" "${TARGET_HOME}/.tmux/scripts/cputemp.sh" 0755
  install_file "${SCRIPT_DIR}/tmux/scripts/fanrpm.sh" "${TARGET_HOME}/.tmux/scripts/fanrpm.sh" 0755
  install_file "${SCRIPT_DIR}/tmux/scripts/membar.sh" "${TARGET_HOME}/.tmux/scripts/membar.sh" 0755
  install_file "${SCRIPT_DIR}/tmux/scripts/netspeed.sh" "${TARGET_HOME}/.tmux/scripts/netspeed.sh" 0755
  install_file "${SCRIPT_DIR}/tmux/scripts/power.sh" "${TARGET_HOME}/.tmux/scripts/power.sh" 0755

  if [[ ! -f "${TARGET_HOME}/.zshrc.local" ]]; then
    install_file "${SCRIPT_DIR}/zsh/.zshrc.local.example" "${TARGET_HOME}/.zshrc.local" 0600
  fi
}

set_default_shell() {
  local zsh_bin
  zsh_bin="$(command -v zsh)"
  local current_shell
  current_shell="$(getent passwd "${TARGET_USER}" | cut -d: -f7)"

  if [[ "${current_shell}" != "${zsh_bin}" ]]; then
    log "Setting default shell to ${zsh_bin}"
    ${SUDO} chsh -s "${zsh_bin}" "${TARGET_USER}"
  else
    log "Default shell already set to ${zsh_bin}"
  fi
}

main() {
  ensure_ubuntu_2404
  install_packages
  install_oh_my_zsh
  install_configs
  set_default_shell

  log "Done"
  cat <<EOF

Installed for user: ${TARGET_USER}
Backups were created with suffix: .bak.${TIMESTAMP}

Next steps:
  1. Review ${TARGET_HOME}/.zshrc.local for machine-specific secrets or overrides.
  2. Start a new shell or run: exec zsh
  3. Reload tmux with: tmux source-file ~/.tmux.conf
  4. Open Vim with: vim
EOF
}

main "$@"
