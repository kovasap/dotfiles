# See https://github.com/chjj/compton/blob/master/compton.sample.conf for
# examples.
compton \
    --glx-prog-win-rule ~kovas/compton/compton-chg-saturate-brightness-contrast.glsl:'!class_g="kitty"' \
    --backend glx -b \
    --inactive-opacity 0.9 --active-opacity 0.95 \
    --opacity-rule 99:'class_g = "Godot" || class_g = "Google-chrome" || class_g = "Aseprite" || class_g = "StardewValley.bin.x86_64" || class_g = "StardewModdingAPI.bin.x86_64"'
    # --blur-background --blur-kern "3x3box"

