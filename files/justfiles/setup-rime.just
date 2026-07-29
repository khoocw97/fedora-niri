# 安装/更新 雾凇拼音 + 万象语法模型 (从镜像内置数据)
setup-rime:
    #!/usr/bin/env bash
    set -euo pipefail
    RIME_DIR="$HOME/.local/share/fcitx5/rime"
    rm -rf "$HOME/.config/fcitx5/rime" "$RIME_DIR"
    mkdir -p "$RIME_DIR"
    cp -r /usr/share/rime-ice/* "$RIME_DIR"
    pgrep -x fcitx5 > /dev/null && fcitx5-remote -r || echo "fcitx5 not running, run 'fcitx5-remote -r' later"
