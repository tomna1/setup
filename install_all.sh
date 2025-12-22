#/usr/bin/env bash

set -euf -o pipefail

setup_fzf() {
  assert_command_not_installed "fzf" "fzf"

  git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
  ~/.fzf/install
}

# setup_helix() {
#   local helix_config_dir=${1}

#   curl https://github.com/helix-editor/helix/releases/tag/25.07.1
# }

setup_zoxide() {
  assert_command_not_installed "zoxide" "zoxide"

  curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
  echo 'eval "$(zoxide init bash --cmd cd)"' >> ~/.bashrc
  echo 'alias cd="z"' >> ~/.bashrc
}

assert_command_not_installed() {
  local cmd="${1}"
  local command_name="${2}"

  if command -v "${cmd}" >/dev/null 2>&1; then
    err '1' "${command_name} is already installed."
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
  setup_zoxide

  # local helix_config_dir="${script_dir}/config/helix"
  # setup_helix ${helix_config_dir}
  #
  echo 'Run the command 'source ~/.bashrc''
}

install_all ${@}
