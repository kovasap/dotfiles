#!/bin/sh

xmenu <<EOF | sh &
Applications->
	IMG:/usr/share/icons/hicolor/48x48/apps/org.xfce.thunar.png	Files	thunar
	IMG:/usr/share/icons/hicolor/48x48/apps/google-chrome.png	Google Chrome	google-chrome-stable
	IMG:/usr/share/icons/hicolor/48x48/apps/steam.png	Steam	steam
	IMG:/usr/share/icons/hicolor/48x48/apps/herioc.png	Heroic	heroic
	IMG:/usr/share/icons/hicolor/48x48/apps/strawberry.png	Music (strawberry)	strawberry
	IMG:/usr/share/icons/hicolor/256x256/apps/kitty.png	Terminal (kitty)	kitty 
	IMG:/usr/share/icons/hicolor/48x48/apps/vdesktop.png	Discord	vesktop 
	IMG:/usr/share/icons/hicolor/32x32/apps/calibre-gui.png	Ebooks (calibre)	calibre
	IMG:./.local/share/icons/mementodb.svg	MementoDB	/opt/mementodb/bin/mementodb
	Terminal (xterm)	xterm
Settings
	IMG:/usr/share/icons/Adwaita/symbolic/status/audio-volume-high-symbolic.svg	Audio	pavucontrol-qt
Qtile
	Logs	kitty zsh -c "nvim ~/.local/share/qtile/qtile.log;read"'
IMG:/usr/share/icons/hicolor/48x48/apps/steam.png	Sleep		systemctl suspend
IMG:/usr/share/icons/Adwaita/symbolic/actions/system-shutdown-symbolic.svg	Shutdown		poweroff
IMG:/usr/share/icons/Adwaita/symbolic/actions/system-reboot-symbolic.svg	Reboot			reboot
EOF

# This command has the advantage of being able to read some data from qtile to
# e.g. populate shortcut keys directly from ~/.config/qtile/config.py, but is
# slower to actully open the menu since it has to run python code.
# python3 ~/.config/qtile/run-xmenu.py
