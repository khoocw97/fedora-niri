# 设定niri 定制配置 (从镜像内置数据 /usr/share/niri-config，会覆盖个人配置)
setup-niri:
    #!/usr/bin/env bash
    set -euo pipefail
    NIRI_DIR="$HOME/.config/niri"
    read -r -p "警告：此操作会覆盖 ~/.config/niri/ 中的个人配置，建议先备份。继续？[y/N] " ans
    case "$ans" in
        [yY]|[yY][eE][sS]) ;;
        *) echo "已取消"; exit 0 ;;
    esac
    mkdir -p "$NIRI_DIR"
    cp -r /usr/share/niri-config/* "$NIRI_DIR"
    niri msg action load-config-file 2>/dev/null || true
