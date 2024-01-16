# Deprecated
#
# This is kept as a fallback if NIX home-manager fails
# or as an instruction to how debug fonts in case smth don't work

echo "Download and install JetBrains Mono Nerd Font"
open https://www.nerdfonts.com/font-downloads

# Check that kitty know about specified font
kitty +list-fonts --psnames | grep Nerd

# verify that desired font is used by kitty
kitty --debug-font-fallback

