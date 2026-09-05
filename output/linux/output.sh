#!/bin/sh
printf '\033c\033]0;%s\a' MGGJ14
base_path="$(dirname "$(realpath "$0")")"
"$base_path/output.x86_64" "$@"
