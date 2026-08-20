#!/usr/bin/env bash
set -euo pipefail

THEME_NAME=Elegant-wave-window-left-dark
SRC=/usr/share/grub/themes/$THEME_NAME
DST=/boot/grub2/themes/$THEME_NAME
USER_CFG=/boot/grub2/user.cfg

mkdir -p /boot/grub2/themes
if [ ! -d "$DST" ]; then
    cp -r "$SRC" "$DST"
fi

if [ ! -f "$USER_CFG" ] || ! grep -q "set theme=" "$USER_CFG"; then
    cat >> "$USER_CFG" <<'EOF'

terminal_output gfxterm
insmod gfxmenu
insmod all_video
insmod png
insmod jpeg
loadfont ($boot)/grub2/themes/Elegant-wave-window-left-dark/terminus-18.pf2
loadfont ($boot)/grub2/themes/Elegant-wave-window-left-dark/unifont-32.pf2
set theme=($boot)/grub2/themes/Elegant-wave-window-left-dark/theme.txt
export theme
EOF
fi
