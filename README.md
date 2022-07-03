# My dotfiles

## Why Customize?

 - Feeling of control over annoyances
 - Use of something inspires ideas for how to improve it

## Features Walkthrough Notes

This is a list of features I commonly use - useful for notes when talking
through my setup.

### QTile

 - Everything is a hotkey!
 - Right click on desktop menu
 - Top bar, element by element
 - Workspaces for different projects
 - Cycling window layouts
 - Clipboard manager, with top bar integration
  - Everything sends to single clipboard, even over ssh
 - Selective window dimming and transparency
 - Resolution and rotation script
 - Bash script hotkeys
   - Example: download youtube shortcut

### Kitty

 - Terminal Emulator
 - Hotkeys to copy lines, open urls
 - Hotkey to open output in vim
 - icat for viewing images
 - Copy/paste over ssh via X11 forwarding

### Zsh

 - Last command autocompletion (shadow autofill)
 - Fzf history search
 - Custom prompt (p10k)
 - Vi mode cursor

### NeoVim

 - Completion based on words in buffers

### Chrome

 - Vimium C
 - Fzf history search


## TODOs

 - Make mod-o go back through a list of old workspaces in qtile, like vim.


## Installation

```
# Install all apt dependencies
sed 's/#.*//' packages-to-install.txt | xargs sudo apt install -y

# Setup ssh so we can pull github repos
# https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent
ssh-keygen -t ed25519 -C "kovas.palunas@gmail.com"
# Hit enter three times
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
# Go to https://github.com/settings/ssh/new and add the keys
# by pasting in the output of:
cat ~/.ssh/id_ed25519.pub

# Install this repo, allowing existing files in home dir to exist.
# Taken from https://stackoverflow.com/questions/9864728/how-to-get-git-to-clone-into-current-directory
cd ~/
git init .
git remote add -t \* -f origin git@github.com:kovasap/dotfiles.git
git checkout master

# Nightly rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
rustup toolchain link system /usr
rustup default system
rustup install nightly

# See https://difftastic.wilfred.me.uk/introduction.html
cargo install difftastic

# TODO remove if unused
# Link udev rules to /etc/udev/rules.d/
sudo ln -s ~/udev_rules/mouse.rules /etc/udev/rules.d/mouse.rules
sudo ln -s ~/udev_rules/fix_mouse_sens.bash /usr/local/bin/fix_mouse_sens.bash
sudo udevadm control --reload
# Can monitor activity with:
# udevadm monitor --environment

# Install activitywatch
# https://docs.activitywatch.net/en/latest/getting-started.html

# Clone, build and install compton: https://github.com/kovasap/compton#how-to-build
git clone git@github.com:kovasap/compton.git
sudo apt install libxcomposite-dev libxdamage-dev libxrender-dev libxrandr-dev libxinerama-dev libconfig-dev libdrm-dev libdbus-1-dev libgl-dev asciidoc
cd compton
make
make docs
sudo make install
cd ~/

# Currently, switching to picom is blocked on
https://github.com/yshui/picom/issues/215 and/or
https://github.com/yshui/picom/pull/247 working properly.
# Clone, build and install picom: https://github.com/jonaburg/picom

# Install clojure tooling
# https://clojure-lsp.io/installation/#script
sudo bash < <(curl -s https://raw.githubusercontent.com/clojure-lsp/clojure-lsp/master/install)

# Install latest neovim
# https://github.com/neovim/neovim/wiki/Installing-Neovim#install-from-download
# Install Paq neovim package manager
git clone --depth=1 https://github.com/savq/paq-nvim.git \
    "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/pack/paqs/start/paq-nvim
# Install plugins
nv -c ":PaqInstall"
# Install vim python package
pip install neovim
pip install 'python-lsp-server[all]'

# Install grive2 for google drive syncing
git clone https://github.com/vitalif/grive2
sudo apt-get install git cmake build-essential libgcrypt20-dev libyajl-dev \
    libboost-all-dev libcurl4-openssl-dev libexpat1-dev libcppunit-dev \
    binutils-dev debhelper zlib1g-dev dpkg-dev pkg-config
cd grive2
mkdir build
cd build
cmake ..
make -j4
sudo make install
cd ~/
mkdir google-drive
cd google-drive
grive -a
cd ~/

# Install google drive syncer
# sudo apt install golang
# go get -u github.com/odeke-em/drive/cmd/drive
# ln -s ~/go/bin/drive bin/drive

# Install xmenu
sudo apt install libxft-dev libimlib2-dev
git clone git@github.com:phillbush/xmenu.git
cd xmenu
make
sudo make install
cd ~/
git clone git@github.com:phillbush/xclickroot.git
cd xclickroot
sudo make clean install
cd ~/

# Install fonts located in ~/.local/share/fonts.
# Installing new fonts should just involve copying them to that dir and running:
fc-cache -f -v
    
# Install oh my zsh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
mv ~/.zshrc.pre-oh-my-zsh ~/.zshrc
# Install zplug
curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh
# Install p10k zsh theme
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
# Install autosuggestions
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# Open a new zsh terminal and run:
zplug install

# Install fzf
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install --key-bindings --completion --no-update-rc

# Install qtile
git clone git@github.com:kovasap/qtile.git
cd qtile
mkvirtualenv qtile
pip install xcffib; pip install cairocffi
pip install -r requirements.txt
pip install .
./scripts/ffibuild
sudo cp qtile-venv.desktop /usr/share/xsessions/
cd ~/
deactivate

# Make sure brightness controls work
sudo chmod a+rw /sys/class/backlight/intel_backlight/brightness

# Colemak with capslock as escape
sudo cp us-xkb-symbols /usr/share/X11/xkb/symbols/us

# Build and install launcher
# https://github.com/enkore/j4-dmenu-desktop
git clone https://github.com/enkore/j4-dmenu-desktop.git
cd j4-dmenu-desktop
cmake .
make
sudo make install
cd ~/

pip3 install bandcamp-downloader

# Chrome extensions:
# https://chrome.google.com/webstore/detail/adblock-%E2%80%94-best-ad-blocker/gighmmpiobklfepjocnamgkkbiglidom
# https://chrome.google.com/webstore/detail/vimium-c-all-by-keyboard/hfjbmagddngcpeloejdejnfgbamkjaeg?hl=en
# https://chrome.google.com/webstore/detail/url-in-title/ignpacbgnbnkaiooknalneoeladjnfgb - useful for selfspy link saving

# Packages to install from github or online download:
# https://github.com/Ventto/lux
# https://github.com/kovasap/selfspy
# https://github.com/dsanson/termpdf.py
```

Also optionally install
https://github.com/kovasap/auto-screenshooter.


## Debugging

### Running `sudo` commands on login/startup

Put commands in `/etc/rc.local` like this:

```
> cat /etc/rc.local
#!/bin/sh -e

# Fixes "dummy output" audio problem
echo "options snd-hda-intel model=generic" | tee -a /etc/modprobe.d/alsa-base.conf
# Allows brightness.sh script to work.
chmod a+rw /sys/class/backlight/intel_backlight/brightness
exit 0
```

### Window Manager Issues

`startx <wm-name>` will start a WM from the terminal.  `startx` with no args will
start the default WM as defined in `~/.xsession` (**i think**).

Possible WMs to start with as understood by a display manager (gdm, lightdm) are
listed in `/usr/share/xsessions`. I think these are also the possibilties that can
be fed to `startx`.

Logs to look at for issues:

 - xorg.log
 - qtile.log

When running QTile with a virtualenv Python, updates to the system Python can break it. 
Re-creating the virtualenv and reinstalling QTile in it should fix the problem. See the
QTile section in the installation commands above.

### NeoVim

One very useful tool for debugging (neo)vim hangs is running `strace -r nvim`.
This helped me determine once that my vim was hanging on quit because it was
trying to cd to an unmounted directory.

## Future Improvements

 - Setting up https://nixos.org/ package management should make installation of
   everything much easier.
 - https://curryncode.com/2018/11/27/using-the-fingerprint-reader-to-unlock-arch-linux/
