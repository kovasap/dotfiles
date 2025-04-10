# udev runs as root, so we need to tell it how to connect to the X server:
xhost +local:
picom \
    --config ~kovas/.config/picom.conf \
    -b
