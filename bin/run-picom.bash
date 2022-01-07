# This currently doesn't work, since picom doesn't support the
# --glx-prog-win-flag, nor does it support any shaders when running the
# --experimental-backend flag.

# See https://github.com/chjj/compton/blob/master/compton.sample.conf for
# examples.
# udev runs as root, so we need to tell it how to connect to the X server:
xhost +local:
picom \
    --config ~kovas/.config/picom.conf \
    --backend glx \
    --experimental-backend
    # --glx-fshader-win "$(cat ~kovas/chg-saturate-brightness-contrast.glsl)"
    # --glx-fshader-win "$(cat ~kovas/chg-saturate-brightness-contrast.glsl)":'!class_g="kitty"'
    # --glx-prog-win-rule ~kovas/compton/compton-chg-saturate-brightness-contrast.glsl:'!class_g="kitty"' \
    #  && !class_g="Atom"
    #  && !class_g="Tabletop Simulator.x86_64"
    # --inactive-opacity 0.9 --active-opacity 0.95 \
    # --opacity-rule 99:'class_g = "Godot" || class_g = "Google-chrome" || class_g = "Aseprite" || class_g = "StardewValley.bin.x86_64" || class_g = "StardewModdingAPI.bin.x86_64"'
    # --blur-background --blur-kern "3x3box"

