git clone https://github.com/jpcrs/dotfiles.git /tmp/dotfiles
cd /tmp/dotfiles && git checkout mac
mv $HOME/.dotfiles/sketchybar $HOME/.dotfiles/sketchybar_backup
mv /tmp/dotfiles/.config/sketchybar $HOME/.dotfiles/sketchybar
rm -rf /tmp/dotfiles
brew services restart sketchybar
