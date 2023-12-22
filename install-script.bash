#!/usr/bin/env bash
set -ueo pipefail
cd "$(dirname "$0")"

CMDNAME=$(basename "$0")
print_usage() {
  cat - << EOF
usage: ${CMDNAME} (-n|-x) [-u <your name>] [-m <your.mail@example.com>]
    -n
        Executes dry run mode; don't actually do anything, just show what will be done.
    -x
        Executes install. This option must be specified if you want to install.
    -u
        Specify your git username. If not given, inputting from tty is required.
    -m
        Specify your git email address. If not given, inputting from tty is required.
EOF
}

MODE=
NAME=
EMAIL=

quote_each_args() {
  for i in $(seq 1 $#); do
    if [[ $i -lt $# ]]; then
      printf '%q ' "${!i}"
    else
      printf '%q' "${!i}"
    fi
  done
}
print_dry_run_message() {
  echo -e "will exec '$*'"
}
run() {
  if [[ "${MODE}" == 'dry-run' ]]; then
    print_dry_run_message "$(quote_each_args "$@")"
  else
    "$@"
  fi
}

while getopts 'nxu:m:' opt; do
  case $opt in
    n) MODE='dry-run' ;;
    x) MODE='execute' ;;
    u) NAME="$OPTARG" ;;
    m) EMAIL="$OPTARG" ;;
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
echo
for file in $(cat dotfiles); do
  run ln -srvbT "${file}" "${HOME}/.${file}"
done

# create .gitconfig.local file
LOCAL_GITCONFIG_FILENAME=.gitconfig.local
if [[ -e "${HOME}/${LOCAL_GITCONFIG_FILENAME}" ]]; then
  echo -e "\n~/${LOCAL_GITCONFIG_FILENAME} already exists; skipping..." >&2
else
  # input name from tty
  if [[ -z "$NAME" ]]; then
    tty -s && echo # insert empty line if input is tty
    read -p 'enter your name for git: ' NAME
    if [[ -z "$NAME" ]]; then
      echo "warning: empty name given. please edit ~/${LOCAL_GITCONFIG_FILENAME} after installing." >&2
    fi
  fi
  # input email from tty
  if [[ -z "$EMAIL" ]]; then
    tty -s && echo # insert empty line if input is tty
    read -p 'enter your email for git: ' EMAIL
    if [[ -z "$EMAIL" ]]; then
      echo "warning: empty email given. please edit ~/${LOCAL_GITCONFIG_FILENAME} after installing." >&2
    fi
  fi
  # generate content and store
  echo
  generate_local_gitconfig_content() {
    cat - << EOF
[core]
    name=${NAME}
    email=${EMAIL}
EOF
  }
  LOCAL_GITCONFIG_CONTENT=$(generate_local_gitconfig_content)
  if [[ "${MODE}" == 'dry-run' ]]; then
    print_dry_run_message "cat - << 'EOF' >~/${LOCAL_GITCONFIG_FILENAME}\n${LOCAL_GITCONFIG_CONTENT}\nEOF"
  else
    echo "${LOCAL_GITCONFIG_CONTENT}" >~/${LOCAL_GITCONFIG_FILENAME}
  fi
fi

# setup vim
echo
run mkdir -p ~/.vim-backup
run mkdir -p ~/.vim-undo
run vim --cmd 'let g:onInitialSetup=1' +PluginInstall +qall
