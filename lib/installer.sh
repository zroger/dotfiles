#!/bin/bash
set -e

# Don't re-evaluate multiple times in the same shell.
test -n "$__dotfile_utils_loaded" && return || __dotfile_utils_loaded=1

abspath() {
    if [[ -d "$1" ]]; then
        cd "$1"
        echo "$(pwd -P)"
    else
        cd "$(dirname "$1")"
        echo "$(pwd -P)/$(basename "$1")"
    fi
}

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
    # Checkmark: U+f058 = 0xef 0x81 0x98
    printf "\x1b[38;5;64m \xef\x81\x98 \x1b[0m %s\n" "$1"
}

info() {
    # Info mark: U+f05a = 0xef 0x81 0x9a
    printf "\x1b[38;5;254m \xef\x81\x9a \x1b[0m %s\n" "$1"
}

error() {
    # X: U+f057 = 0xef 0x81 0x97
    printf "\x1b[38;5;254m \xef\x81\x97 \x1b[0m %s\n" "$1"
}

symlink() {
    local src dst name
    src="$(abspath "${DOTFILES}/$1")"
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

    mkdir -p "$(dirname "$dst")"
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

assert_bin() {
    [ -x "$(which "$1")" ] || {
        echo "${1} is required."
        exit 1
    }
}


linuxbrew() {
    [ -x "$(which brew)" ] && {
        ok linuxbrew
        return
    }

    linux || {
        error "Linuxbrew can only be installed on linux."
        exit 1
    }
    assert_bin curl
    assert_bin git

    HOMEBREW_PATH="${HOME}/.linuxbrew"
    BREW_REPO="https://github.com/Linuxbrew/brew"
    info "Installing linuxbrew to ~/.linuxbrew"
    git clone "${BREW_REPO}" "${HOMEBREW_PATH}" >> ~/.dotfiles.log 2>&1
    if [ $? -eq 0 ]; then
        ok "Linuxbrew installed."
    else
        error "Failed to install Linuxbrew. Check ~/.dotfiles.log for more info."
    fi

    info "Tapping Hombrew/bundle"
    "$HOMEBREW_PATH"/bin/brew tap Homebrew/bundle >> ~/.dotfiles.log 2>&1
    if [ $? -eq 0 ]; then
        ok "Homebrew/bundle tapped."
    else
        error "Failed to tap Homebrew/bundle. Check ~/.dotfiles.log for more info."
    fi
}
