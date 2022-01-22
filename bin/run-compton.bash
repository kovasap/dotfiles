# See https://github.com/chjj/compton/blob/master/compton.sample.conf for
# examples.
# udev runs as root, so we need to tell it how to connect to the X server:
xhost +local:
compton \
    --glx-prog-win-rule ~kovas/compton-chg-saturate-brightness-contrast.glsl:'!(class_g="kitty" || name="qtile_bar")' \
    --backend glx -b \
    --opacity-rule 93:'(class_g="kitty" || name="qtile_bar")'
    # --opacity-rule 80:'(class_g = "Godot" || class_g = "Google-chrome" || class_g = "Aseprite" || class_g = "StardewValley.bin.x86_64" || class_g = "StardewModdingAPI.bin.x86_64")'
    # --opacity-rule 93:'(class_g="kitty" || name="qtile_bar")'

# Other options to try:
    # --inactive-dim 0.1
    # --inactive-opacity 0.9 --active-opacity 0.95
    # --blur-background --blur-kern "3x3box"

