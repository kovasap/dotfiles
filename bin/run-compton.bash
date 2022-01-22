# See https://github.com/chjj/compton/blob/master/compton.sample.conf for
# examples.
# udev runs as root, so we need to tell it how to connect to the X server:
xhost +local:
compton \
    --glx-prog-win-rule ~kovas/compton-chg-saturate-brightness-contrast.glsl:'!(class_g="kitty" || name="qtile_bar")' \
    --backend glx -b \
    --config ~/.config/compton.conf
