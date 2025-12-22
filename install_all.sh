#/usr/bin/env bash

set -euf -o pipefail

setup_fzf() {
  if [ $(command -v fzf | echo ${?}) == 0 ]; then
    err "1" "fzf is already installed."
  fi

  git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
  ~/.fzf/install
}

# setup_helix() {
#   local helix_config_dir=${1}

#   curl https://github.com/helix-editor/helix/releases/tag/25.07.1
# }

err() {
  echo "Error: ${2}" >&2
  exit ${1}
}

log() {
  echo "Log: ${1}"
}

install_all() {
  local script_dir
  script_dir="$( cd -- $( dirname -- "${BASH_SOURCE[0]}") &> /dev/null && pwd )"

  setup_fzf

  # local helix_config_dir="${script_dir}/config/helix"
  # setup_helix ${helix_config_dir}
}

install_all ${@}
