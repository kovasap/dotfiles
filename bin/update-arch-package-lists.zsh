#!/bin/zsh

echo "-----------------------------"
echo "pacman"
echo "-----------------------------"
pacman -Qqen > pacman_packages.txt
cat pacman_packages.txt
echo "-----------------------------"
echo "yay"
echo "-----------------------------"
yay -Qqem > yay_packages.txt
cat yay_packages.txt
