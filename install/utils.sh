#!/bin/bash
set -e

# Don't re-evaluate multiple times in the same shell.
test -n "$__dotfile_utils_loaded" && return || __dotfile_utils_loaded=1

format_path() {
    printf "%s" "${1/"$HOME"/"~"}"
}

BACKUP_DIR="${HOME}/dotfiles-backup/$(date +%s)"
backup() {
    local backup_path="$BACKUP_DIR/${1#"${HOME}/"}"
    mkdir -p "$(dirname "$backup_path")"
    mv "$1" "$backup_path"
}

ok() {
    gprintf "\x1b[38;5;64m \uf058 \x1b[0m %s\n" "$1"
}

info() {
    gprintf "\x1b[38;5;254m \uf05a \x1b[0m %s\n" "$1"
}

symlink() {
    local src dst name
    src="$(realpath "$1")"
    dst="$2"
    name="$(format_path "$dst")"

    if [[ -L "$dst" && "$(readlink "$dst")" == "$src" ]]; then
        ok "$name"
        return

    elif [[ -L "$dst" || -e "$dst" ]]; then
        backup "$dst" && {
            info "Existing ${name} backed up to ${BACKUP_DIR}"
        }
    fi

    ln -s "$src" "$dst" && {
        ok "${name} installed"
    }
}

header() {
    printf "\n%s  %s\x1b[K%s\n" \
        "$(tput setab 240)$(tput setaf 254)" \
        "$1" \
        "$(tput sgr0)"
}

mac_os() {
    [[ "$(uname)" == "Darwin" ]]
}

linux() {
    [[ "$(uname)" == "Linux" ]]
}