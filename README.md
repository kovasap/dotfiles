# My dotfiles

## Installation

```
# Install this repo, allowing existing files in home dir to exist.
# Taken from https://stackoverflow.com/questions/9864728/how-to-get-git-to-clone-into-current-directory
cd ~/
git init .
git remote add -t \* -f origin git@github.com:kovasap/dotfiles.git
git checkout master

# Link udev rules to /etc/udev/rules.d/
sudo ln -s ~/udev_rules/mouse.rules /etc/udev/rules.d/mouse.rules
sudo ln -s ~/udev_rules/fix_mouse_sens.bash /usr/local/bin/fix_mouse_sens.bash
sudo udevadm control --reload
# Can monitor activity with:
# udevadm monitor --environment

# Install neovim
sudo apt install neovim

# Install zsh
sudo apt install zsh
# Install oh my zsh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
# Install zplug
curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh
# Install p10k zsh theme
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
# Install autosuggestions
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# Install fzf
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

# Install virtualenvwrapper
sudo apt install virtualenvwrapper

# Install kitty - this is necessary to get the terminal working properly even
# on a remote server, since otherwise the TERM=xterm-kitty env var wont be
# recognized.
sudo apt install kitty

# Install tldr (https://tldr.sh/)
sudo apt install tldr

# Install maim for cool screenshot-to-clipboard functionality with printscreen.
sudo apt install maim
```

Also install https://github.com/kovasap/auto-screenshooter.


## Debugging


### NeoVim

One very useful tool for debugging (neo)vim hangs is running `strace -r nvim`.
This helped me determine once that my vim was hanging on quit because it was
trying to cd to an unmounted directory.
