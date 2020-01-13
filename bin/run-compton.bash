# See https://github.com/chjj/compton/blob/master/compton.sample.conf for
# examples.
compton --glx-prog-win-rule ~kovas/compton/compton-chg-saturate-brightness-contrast.glsl:'class_g="Google-chrome"' --backend glx -b \
    --inactive-opacity 0.9 --active-opacity 0.95 \
    # --blur-background --blur-kern "3x3box"

