# This currently doesn't work, since picom doesn't support the
# --glx-prog-win-flag, nor does it support any shaders when running the
# --experimental-backend flag.

# See https://github.com/chjj/compton/blob/master/compton.sample.conf for
# examples.
# udev runs as root, so we need to tell it how to connect to the X server:
xhost +local:
picom \
    --config ~kovas/.config/picom.conf \
    -b \
    --window-shader-fg-rule=picom-brightness.glsl:'(class_g="Google-chrome" || class_g="google-chrome")'
