if [ -f ~/.bashrc ]; then
  source ~/.bashrc
fi

for f in ~/.config/bash/profile.d/*.sh; do
    source "$f"
done
