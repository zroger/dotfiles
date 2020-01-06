# :house: dotfiles
> home is where your dotfiles are

## Installation


```sh
# clone this repo
git clone https://github.com/zroger/dotfiles.git ~/dotfiles

# install homebrew
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# install homebrew packages
brew bundle install --file=~/dotfiles/Brewfile --no-lock

# install dotfiles
~/dotfiles/install.sh
```
