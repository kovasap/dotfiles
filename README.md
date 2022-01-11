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

# Install activitywatch

# Clone, build and install compton: https://github.com/kovasap/compton#how-to-build
# Currently, switching to picom is blocked on
https://github.com/yshui/picom/issues/215 and/or
https://github.com/yshui/picom/pull/247 working properly.
# Clone, build and install picom: https://github.com/jonaburg/picom

sudo apt install xinput
sudo apt install xdotool

# Install copyq clipboard manager
sudo apt install copyq

# Install clojure tooling
# https://clojure-lsp.io/installation/#script
# Rust required for parinfer, which is installed during vim plugin install.
sudo apt install rustc
# Useful for cljs projects
sudo apt install npm

# Install neovim
sudo apt install neovim
# Install Paq neovim package manager
git clone --depth=1 https://github.com/savq/paq-nvim.git \
    "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/pack/paqs/start/paq-n vim
# Install vim python package
pip install neovim

sudo apt install silversearcher-ag
    
# Install firacode font
sudo apt install fonts-firacode

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

# Install qtile
git clone git@github.com:kovasap/qtile.git
cd qtile
mkvirtualenv qtile
sudo apt install libiw-dev
pip install -r requirements.txt
pip install .
sudo apt install libpulse-dev
./scripts/ffibuild
sudo cp qtile-venv.desktop /usr/share/xsessions/
cd ~/

# Install kitty - this is necessary to get the terminal working properly even
# on a remote server, since otherwise the TERM=xterm-kitty env var wont be
# recognized.
sudo apt install kitty

# Install maim for cool screenshot-to-clipboard functionality with printscreen.
sudo apt install maim

sudo apt install tldr # https://tldr.sh/
sudo apt install bat # https://github.com/sharkdp/bat
sudo apt install j4-dmenu-desktop
sudo apt install cmatrix
sudo apt install qdirstat
sudo apt install xautolock
sudo apt install cmake
sudo apt install cmus
# See also https://github.com/hakerdefo/cmus-lyrics
sudo apt install feh
sudo apt install visidata
pip install bandcamp-dl

# Chrome extensions:
# https://chrome.google.com/webstore/detail/adblock-%E2%80%94-best-ad-blocker/gighmmpiobklfepjocnamgkkbiglidom
# https://chrome.google.com/webstore/detail/vimium-c-all-by-keyboard/hfjbmagddngcpeloejdejnfgbamkjaeg?hl=en
# https://chrome.google.com/webstore/detail/url-in-title/ignpacbgnbnkaiooknalneoeladjnfgb - useful for selfspy link saving

# Packages to install from github or online download:
# https://github.com/Ventto/lux
# https://github.com/kovasap/selfspy
# https://github.com/kovasap/compton
# https://github.com/dsanson/termpdf.py
```

Also install https://github.com/kovasap/auto-screenshooter.


## Debugging


### NeoVim

One very useful tool for debugging (neo)vim hangs is running `strace -r nvim`.
This helped me determine once that my vim was hanging on quit because it was
trying to cd to an unmounted directory.
