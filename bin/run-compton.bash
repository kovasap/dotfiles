# See https://github.com/chjj/compton/blob/master/compton.sample.conf for
# examples.
compton \
    --glx-prog-win-rule ~kovas/compton/compton-chg-saturate-brightness-contrast.glsl:'!class_g="kitty"' \
    --backend glx -b \
    --inactive-opacity 0.9 --active-opacity 0.95 \
    --opacity-rule '99:class_g = "Google-chrome"'  # not sure why 99 works but 100 doesn't here...
    # --blur-background --blur-kern "3x3box"

