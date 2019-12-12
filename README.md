# :house: dotfiles
> home is where your dotfiles are

## Installation


```sh
# clone this repo
git clone https://github.com/zroger/dotfiles.git ~/dotfiles/public

# install homebrew
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# install homebrew packages
brew bundle install --file=~/dotfiles/public/Brewfile --no-lock

# install dotfiles
env RCRC=$HOME/dotfiles/public/rcrc rcup
```
