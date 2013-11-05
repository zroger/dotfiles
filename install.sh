#!/usr/bin/env bash

for name in *; do
    target="$HOME/.$name"
    if [ -e "$target" ]; then
        if [ ! -L "$target" ]; then
            echo "WARNING: $target exists but is not a symlink."
        fi
    else
        if [ "$name" != 'install.sh' ] && [ "$name" != 'README.md' ]; then
            echo "Creating $target"
            ln -s "$PWD/$name" "$target"
        fi
    fi
done

vundle_path="$HOME/.vim/bundle/vundle"
[[ -d $vundle_path ]] || git clone https://github.com/gmarik/vundle.git $vundle_path
vim +BundleInstall +qall


# Install virtualenvwrapper into local pip directory
if [ ! -f "$HOME/.local/bin/virtualenvwrapper.sh" ]; then
    pip install --install-option="--user" virtualenvwrapper
fi

