# See https://github.com/chjj/compton/blob/master/compton.sample.conf for
# examples.
# udev runs as root, so we need to tell it how to connect to the X server:
xhost +local:
# Make chrome the dimmest, as it likely will have white webpages on it.
# Everything else should be medium dimmness, except for kitty and the qtile
# bar.  We need to exclude chrome from the second flag value so it doesn't get
# double applied.
compton \
    --glx-prog-win-rule ~kovas/compton-chg-saturate-brightness-contrast.glsl:'(class_g="Google-chrome")' \
    --glx-prog-win-rule ~kovas/compton-chg-saturate-brightness-contrast-medium.glsl:'!(class_g="kitty" || name="qtile_bar" || class_g="Google-chrome")' \
    --backend glx \
    --config ~/.config/compton.conf
