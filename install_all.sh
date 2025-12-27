#!/usr/bin/env bash

set -euo pipefail

install_jq() {
  if is_installed "jq"; then
    echo "jq is already installed, skipping..."
    return 0
  fi

  sudo apt install -y jq
}

setup_fzf() {
  if is_installed "fzf"; then
    echo "fzf is already installed, skipping..."
    return 0
  fi

  git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
  ~/.fzf/install
  echo 'eval "$(fzf --bash)"' >> ~/.bashrc
  echo 'export PATH="${HOME}/.fzf/bin:${PATH}"'
}

setup_helix() {
  if is_installed "hx"; then
    echo "hx is already installed, skipping..."
    return 0
  fi

  local helix_config_dir="${1}"

  install_jq

  local tmpdir
  tmpdir="$(mktemp -d)"

  local latest_release_tag
  latest_release_tag="$(curl -s https://api.github.com/repos/helix-editor/helix/releases/latest | jq -r .tag_name)"
  curl -L "https://github.com/helix-editor/helix/releases/download/${latest_release_tag}/helix-${latest_release_tag}-x86_64-linux.tar.xz" -o "${tmpdir}/helix.tar.xz"
  mkdir -p "${tmpdir}/helix"
  tar -xf "${tmpdir}/helix.tar.xz" -C "${tmpdir}/helix" --strip-components=1

  mkdir -p "${HOME}/.local/helix-${latest_release_tag}"
  mkdir -p "${HOME}/.local/bin"
  mv "${tmpdir}/helix/hx" "${HOME}/.local/helix-${latest_release_tag}/hx"
  mv "${tmpdir}/helix/runtime" "${HOME}/.local/helix-${latest_release_tag}/runtime"
  mv "${tmpdir}/helix/contrib" "${HOME}/.local/helix-${latest_release_tag}/contrib"
  ln -s "${HOME}/.local/helix-${latest_release_tag}/hx" "${HOME}/.local/bin/hx"
  rm -r "${tmpdir}"

  mkdir -p "${HOME}/.config/helix"
  cp "${helix_config_dir}/config.toml" "${HOME}/.config/helix/config.toml"
}

setup_zoxide() {
  if is_installed "zoxide"; then
    echo "zoxide is already installed, skipping..."
    return 0
  fi

  curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
  echo 'eval "$(zoxide init bash)"' >> ~/.bashrc
  echo 'alias cd="z"' >> ~/.bashrc
}

is_installed() {
  local cmd="${1}"
  if type -P "${cmd}" >/dev/null 2>&1; then
    return 0
  else
    return 1
  fi
}

err() {
  local exit_code="${1}"
  local error_message="${2}"

  echo "Error: ${error_message}" >&2
  exit "${exit_code}"
}

log() {
  local log_message="${1}"

  echo "Log: ${log_message}"
}

install_all() {
  local script_dir
  script_dir="$( cd -- $( dirname -- "${BASH_SOURCE[0]}") &> /dev/null && pwd )"

  setup_fzf
  # setup_zoxide

  local helix_config_dir="${script_dir}/config/helix"
  setup_helix ${helix_config_dir}

  echo 'Run the command 'source ~/.bashrc''
}

install_all ${@}
