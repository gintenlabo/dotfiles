#!/usr/bin/env bash
set -ueo pipefail

cd "$(dirname "$0")/.." # move to project root

LINK_IGNORE="${LINK_IGNORE:-.linkignore}"

CMDNAME=$(basename "$0")
print_usage() {
  cat - << EOF
usage: ${CMDNAME} [options...]
    -v
        Verbose mode; print tracked files and ignored files.
    -h
        Print this message and exit.
EOF
}

VERBOSE=

while getopts 'vh' opt; do
  case $opt in
    v) VERBOSE='on' ;;
    h) print_usage
       exit ;;
    *) print_usage >&2
       exit 1 ;;
  esac
done

remove_directory_contents() {
  cat - | sed 's/\/.*//g' | sort -u
}

TRACKED_FILES=$(git ls-files -c | grep -v '^\.')
if [[ -n "${VERBOSE}" ]]; then
  echo "tracked files:" >&2
  echo -e "${TRACKED_FILES}\n" >&2
fi

IGNORED_FILES=$(git ls-files -ic --exclude-from="${LINK_IGNORE}")
if [[ -n "${VERBOSE}" ]]; then
  echo "ignored files:" >&2
  echo -e "${IGNORED_FILES}\n" >&2
fi

echo "${TRACKED_FILES}" | grep -vxFf <(echo "${IGNORED_FILES}") | remove_directory_contents
