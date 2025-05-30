#!/usr/bin/env bash
set -ueo pipefail
cd "$(dirname "$0")"

CMDNAME="$(basename "$0")"
print_usage() {
  cat - << EOF
usage: ${CMDNAME} (-n|-x) [options...]
    -n
        Executes dry run mode; don't actually do anything, just show what will be done.
    -x
        Executes install. This option must be specified if you want to install.
    -o
        Overwrites existing ~/.gitconfig.local with backup (~/.gitconfig.local~ if backup suffix is '~').
    -S <suffix>
        Specify backup suffix.
        If not given, BACKUP_SUFFIX is used; neither is given, '~' is used.
        This argument cannot be empty string.
    -u <your name>
        Specify your git username. If not given, inputting from tty is required.
    -m <your-email.example.com>
        Specify your git email address. If not given, inputting from tty is required.
EOF
}

MODE=
NAME=
EMAIL=
OVERWRITE=
BACKUP_SUFFIX="${BACKUP_SUFFIX:-"~"}"

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
print_executing_message() {
  echo -e "executing '$*'..."
}
run() {
  if [[ "${MODE}" == 'dry-run' ]]; then
    print_dry_run_message "$(quote_each_args "$@")"
  else
    print_executing_message "$(quote_each_args "$@")"
    "$@"
    echo 'done.'
  fi
}
backup() {
  if [[ "$#" -ne 1 ]]; then
    echo "assertion failed: invalid argument count for backup(); expected 1, got $#." >&2
    exit 255
  fi
  local path="$1"
  if [[ -e "${path}" ]]; then
    local backup_path="${path}${BACKUP_SUFFIX}"
    if [[ -e "${backup_path}" ]]; then
      echo "error: backup file for path '${path}' ('${backup_path}') already exists." >&2
      echo "aborting..." >&2
      exit 1
    fi
    run mv "${path}" "${backup_path}"
  fi
}

while getopts 'nxoS:u:m:' opt; do
  case $opt in
    n) MODE='dry-run' ;;
    x) MODE='execute' ;;
    S) BACKUP_SUFFIX="$OPTARG" ;;
    u) NAME="$OPTARG" ;;
    m) EMAIL="$OPTARG" ;;
    o) OVERWRITE='on' ;;
    *) print_usage >&2
       exit 1 ;;
  esac
done
if [[ -z "${MODE}" || -z "${BACKUP_SUFFIX}" ]]; then
  print_usage >&2
  exit 1
fi

# init submodules
run git submodule update --init

# create symbolic links
echo
./install-script-tools/ls-linking-files.bash | while read -r file; do
  DOTFILE_PATH="${HOME}/.${file}"
  backup "${DOTFILE_PATH}"
  run ln -srvT "${file}" "${DOTFILE_PATH}"
done

# create .gitconfig.local file
LOCAL_GITCONFIG_PATH="${HOME}/.gitconfig.local"
if [[ -z "${OVERWRITE}" && -e "${LOCAL_GITCONFIG_PATH}" ]]; then
  echo -e "\n${LOCAL_GITCONFIG_PATH} already exists; skipping..." >&2
else
  # input name from tty
  if [[ -z "$NAME" ]]; then
    tty -s && echo # insert empty line if input is tty
    read -p 'enter your name for git: ' NAME
    if [[ -z "$NAME" ]]; then
      echo "warning: empty name given. please edit ${LOCAL_GITCONFIG_PATH} after installation." >&2
    fi
  fi
  # input email from tty
  if [[ -z "$EMAIL" ]]; then
    tty -s && echo # insert empty line if input is tty
    read -p 'enter your email for git: ' EMAIL
    if [[ -z "$EMAIL" ]]; then
      echo "warning: empty email given. please edit ${LOCAL_GITCONFIG_PATH} after installation." >&2
    fi
  fi
  # generate content and store
  echo
  generate_local_gitconfig_content() {
    cat - << EOF
[user]
    name = ${NAME}
    email = ${EMAIL}
EOF
  }
  LOCAL_GITCONFIG_CONTENT="$(generate_local_gitconfig_content)"
  # backup if there is ~/.gitconfig.local already
  backup "${LOCAL_GITCONFIG_PATH}"
  LOCAL_GITCONFIG_CREATION_COMMAND="cat - << 'EOF' >$(printf '%q' "${LOCAL_GITCONFIG_PATH}")\n${LOCAL_GITCONFIG_CONTENT}\nEOF"
  if [[ "${MODE}" == 'dry-run' ]]; then
    print_dry_run_message "${LOCAL_GITCONFIG_CREATION_COMMAND}"
  else
    print_executing_message "${LOCAL_GITCONFIG_CREATION_COMMAND}"
    echo "${LOCAL_GITCONFIG_CONTENT}" >"${LOCAL_GITCONFIG_PATH}"
    echo 'done.'
  fi
fi

# setup vim
echo
run mkdir -p ~/.vim-backup
run mkdir -p ~/.vim-undo
run vim --cmd 'let g:onInitialSetup=1' +PluginInstall +qall

# install homebrew
echo
if type brew &>/dev/null ; then
  echo -e "homebrew already installed." >&2
else
  run sudo apt update
  run sudo apt install build-essential procps curl file git
  if [[ "${MODE}" == 'dry-run' ]]; then
    print_dry_run_message '/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)'
    print_dry_run_message 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"'
  else
    print_executing_message '/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)'
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    echo 'done.'
    print_executing_message 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"'
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    echo 'done.'
  fi
fi
run brew bundle install --file=Brewfile
