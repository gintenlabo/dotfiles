#!/usr/bin/env bash
set -ueo pipefail
cd "$(dirname "$0")"

CMDNAME=$(basename "$0")
print_usage() {
  cat - << EOF
usage: ${CMDNAME} (-n|-x)
    -n
        Executes dry run mode; don't actually do anything, just show what will be done.
    -x
        Executes install. This option must be specified if you want to install.
EOF
}

MODE=

quote_each_args() {
  local args=("$@")
  for i in "${!args[@]}"; do
    if [[ $i -lt $((${#args[@]} - 1)) ]]; then
      printf '%q ' "${args[$i]}"
    else
      printf '%q' "${args[$i]}"
    fi
  done
}
run() {
  if [[ "${MODE}" == 'dry-run' ]]; then
    echo "will exec '$(quote_each_args "$@")'"
  else
    "$@"
  fi
}

while getopts 'nx' opt; do
  case $opt in
    n) MODE='dry-run' ;;
    x) MODE='execute' ;;
    *) print_usage >&2
       exit 1 ;;
  esac
done
if [[ -z "${MODE}" ]]; then
  print_usage >&2
  exit 1
fi

# init submodules
run git submodule update --init

# create symbolic links
for file in $(cat dotfiles); do
  run ln -srvbT "${file}" "${HOME}/.${file}"
done

# TODO: create .gitconfig.local file

# setup vim
run mkdir -p ~/.vim-backup
run mkdir -p ~/.vim-undo
run vim +PluginInstall +qall
