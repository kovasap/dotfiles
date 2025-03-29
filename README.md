# My dotfiles

See feature overview at [FEATURES.md](FEATURES.md).

## Why Customize?

 - Feeling of control over annoyances
 - Use of something inspires ideas for how to improve it

## Installation

### For All Systems

May need to install some packages from `pacman_packages.txt` or
`packages-to-install.txt` to run some of these commands.

```
# Note, look for *.ssh directories in my home dir in case i copied frequently used keys for e.g. cloud machines.
# Setup ssh so we can pull github repos
# https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent
ssh-keygen -t ed25519 -C "kovas.palunas@gmail.com"
# Hit enter three times
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
# Go to https://github.com/settings/ssh/new and add the keys
# by pasting in the output (without newlines) of:
cat ~/.ssh/id_ed25519.pub

# Install this repo, allowing existing files in home dir to exist.
# Taken from https://stackoverflow.com/questions/9864728/how-to-get-git-to-clone-into-current-directory
cd ~/
git init .
git remote add -t \* -f origin git@github.com:kovasap/dotfiles.git
git pull
git checkout master

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

# Install my cron jobs
crontab ~/crontab

# Jet for handy formatting
bash < <(curl -s https://raw.githubusercontent.com/borkdude/jet/master/install)

# Required for copyq to work
sudo dbus-uuidgen > /var/lib/dbus/machine-id

# Gdrive CLI is handy
https://github.com/glotlabs/gdrive?tab=readme-ov-file

# Get Gemini API key
# Go to https://aistudio.google.com/apikey
# Then make a file like 
echo "export GEMINI_API_KEY='<key>' >> ~/gemini_api_key.zsh"
# This is useful to use https://github.com/kiddos/gemini.nvim
```

#### Arch Linux (Graphical)

```
pacman -S - < pacman_packages.txt

# Networking
sudo systemctl enable systemd-networkd
sudo systemctl enable systemd-resolved
sudo systemctl start systemd-resolved
sudo systemctl start systemd-networkd
ln -sf ../run/systemd/resolve/stub-resolv.conf /etc/resolv.conf

# Time
timedatectl set-ntp true

# Install yay
sudo pacman -S --needed git base-devel
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si

yay -S - < yay_packages.txt

# Clone, build and install compton: https://github.com/kovasap/compton#how-to-build
git clone git@github.com:kovasap/compton.git
cd compton
make
make docs
sudo make install
cd ~/

```

#### All Others

```
# Install linuxbrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install all apt dependencies
sed 's/#.*//' packages-to-install.txt | xargs sudo apt install -y
curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin

# Nightly rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
rustup toolchain link system /usr
rustup default system
rustup install nightly

# See https://difftastic.wilfred.me.uk/introduction.html
cargo install difftastic

# Install latest neovim
# https://github.com/neovim/neovim/wiki/Installing-Neovim#install-from-download
# sudo apt install neovim neovim-runtime
# If installing from a package manager like apt, make sure neovim-runtime is
# also installed, otherwise some plugins wont work (like lsp and treesitter).
#
# Linuxbrew has usually a more up to date verion of nvim.
brew install neovim
cd .local/share/nvim/site/pack/paqs/start/parinfer-rust/
cargo build --release
cd ~/
# Install vim python package
pip install neovim
pip install 'python-lsp-server[all]'

# Linuxbrew and clojure
brew install clojure/tools/clojure
brew install borkdude/brew/babashka

# TODO remove if unused
# Link udev rules to /etc/udev/rules.d/
sudo ln -s ~/udev_rules/mouse.rules /etc/udev/rules.d/mouse.rules
sudo ln -s ~/udev_rules/fix_mouse_sens.bash /usr/local/bin/fix_mouse_sens.bash
sudo udevadm control --reload
# Can monitor activity with:
# udevadm monitor --environment

# Install activitywatch into ~/activitywatch/
# https://docs.activitywatch.net/en/latest/getting-started.html
# It will be autostarted via ~/.xinitrc

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
# zprint for formatting https://github.com/kkinnear/zprint/releases


# Install Joker
# https://github.com/candid82/joker/releases

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
grive -a -P -f
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
# Alternatively, install qtile from pipx and use .xsession to run it:
# pipx install qtile
# pipx inject qtile psutil
# pipx inject qtile Xlib

# Make sure brightness controls work
sudo chmod a+rw /sys/class/backlight/intel_backlight/brightness
# Make sure this happens every time on boot
sudo cp rc.local /etc/rc.local

# Colemak with capslock as escape
sudo cp keyboard/us-xkb-symbols /usr/share/X11/xkb/symbols/us
sudo cp keyboard/pc-types /usr/share/X11/xkb/types/pc

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

`startx <wm-name>` will start a WM from the terminal.
`startx` with no args will start the default WM as defined in `~/.xsession` (**i
think**).
You can also just start qtile directly to troubleshoot via `qtile start`.

Possible WMs to start with as understood by a display manager (gdm, lightdm) are
listed in `/usr/share/xsessions`.
I think these are also the possibilities that can be fed to `startx`.

Logs to look at for issues:

 - xorg.log in ~/.local/share/xorg/Xorg.1.log and /var/log/
 - ~/.xsession-errors
 - ~/.local/share/qtile/qtile.log

When running QTile with a virtualenv Python, updates to the system Python can
break it.
Re-creating the virtualenv and reinstalling QTile in it should fix the problem.
See the QTile section in the installation commands above.

### NeoVim

One very useful tool for debugging (neo)vim hangs is running `strace -r nvim`.
This helped me determine once that my vim was hanging on quit because it was
trying to cd to an unmounted directory.

## Windows

Use a USB with Ventoy and a official ISO to install.
Can also install other stuff like memtest on the same usb with Ventoy.

### Programs to Install

 - [ ] foobar2000
 - [ ] Nvidia stuff
 - [ ] VLC media player
 - [ ] Steam
 - [ ] Google Drive Syncer
 - [ ] https://github.com/Toxblh/WinToLinux
 - [ ] https://pangobright.com/

### Automatic Screenshooting

1. Download https://www.nirsoft.net/utils/nircmd.html
2. Make a new task in Windows "Task Scheduler" with program `cmd.exe` and arguments `/c C:\Users\kovas\Downloads\nircmd\nircmd.exe savescreenshotfull "C:\Users\kovas\OneDrive\Pictures\Screenshots\screenshot_%time:~0,2%%time:~3,2%%time:~6,2%_%date:~-10,2%%date:~-7,2%%date:~-4,4%.png"`
     - This actually is problematic because if you use the "Run only when user is logged on" option, you will get a popup command line when the command executes that gets included in the screenshot.  If you use "Run whether user is logged on or not, the screenshots will be black".  To fix this, use program `C:\Users\kovas\Downloads\nircmd\nircmd.exe`
     - You can set this program by adding a new "Action" to the task
 and argument `savescreenshotfull "C:\Users\kovas\OneDrive\Pictures\Screenshots\screenshot.png"`.  Then you need to make sure this is synced to Google photos before it gets overwritten.  Or make another task to move it to a unique filename with program `cmd.exe`.
4. Set the task to run on your preferred schedule by adding a new "Trigger".
5. Use the Google Drive app to sync your screenshot directory to Google Photos.

