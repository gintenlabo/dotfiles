#!/usr/bin/env bash
set -ueo pipefail
WORKDIR=$(pwd)
cd "$(dirname "$0")"

CMDNAME=$(basename "$0")
print_usage() {
  cat - << EOF
usage: ${CMDNAME} (-n|-x) [options...] [files...]
    -n
        Executes dry run mode; don't actually do anything, just show what will be done.
    -x
        Executes restoration. This option must be specified if you want to restore.
    -d
        Deletes given file if no backup found.
    -S <suffix>
        Specify backup suffix.
        If not given, BACKUP_SUFFIX is used; neither is given, '~' is used.
        This argument cannot be empty string.
    files
        Specify file paths to restore.
        If not given, files would be linked by install-script and ~/.gitconfig.local is restored.
EOF
}

MODE=
DELETE=
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
restore() {
  for file in "$@"; do
    local backup="${file}${BACKUP_SUFFIX}"
    if [[ -e "${backup}" ]]; then
      run rm -f "${file}"
      run mv "${backup}" "${file}"
    elif [[ -n "${DELETE}" ]]; then
      run rm -f "${file}"
    fi
  done
}

while getopts 'nxS:d' opt; do
  case $opt in
    n) MODE='dry-run' ;;
    x) MODE='execute' ;;
    S) BACKUP_SUFFIX="$OPTARG" ;;
    d) DELETE='on' ;;
    *) print_usage >&2
       exit 1 ;;
  esac
done
if [[ -z "${MODE}" || -z "${BACKUP_SUFFIX}" ]]; then
  print_usage >&2
  exit 1
fi

shift $((OPTIND - 1))

if [[ $# -eq 0 ]]; then
  ./ls-linking-files.bash | while read -r filename; do
    restore "${HOME}/.${filename}"
  done
  restore ~/.gitconfig.local
else
  (cd "${WORKDIR}" && restore "$@")
fi
