setup-rime:
    #!/usr/bin/env bash
    # 安装(本地内置数据) / 更新(git 拉取最新) / 取消 (方向键上下选择，回车确认)
    set -euo pipefail
    RIME_DIR="$HOME/.local/share/fcitx5/rime"
    GREEN=$'\033[1;32m'
    NC=$'\033[0m'

    labels=(安装 更新 取消)
    values=(install update cancel)
    sel=0
    n=0
    while true; do
        if [ "$n" -gt 0 ]; then printf '\033[4A\033[0J'; fi
        for i in "${!labels[@]}"; do
            if [ "$i" -eq "$sel" ]; then
                printf '%b> %s%b\n' "$GREEN" "${labels[$i]}" "$NC"
            else
                printf '  %s\n' "${labels[$i]}"
            fi
        done
        printf '\033[90m%s\033[0m\n' '↑/↓ 选择，回车确认'
        n=1
        read -r -s -n 1 key
        case "$key" in
            $'\e')
                read -r -s -n 2 -t 0.1 seq || true
                if [ "$seq" = '[A' ]; then
                    sel=$(( (sel - 1 + ${#labels[@]}) % ${#labels[@]} ))
                elif [ "$seq" = '[B' ]; then
                    sel=$(( (sel + 1) % ${#labels[@]} ))
                fi
                ;;
            '') break ;;
        esac
    done

    case "${values[$sel]}" in
        cancel)
            echo "取消"
            ;;
        install)
            rm -rf "$HOME/.config/fcitx5/rime" "$RIME_DIR"
            mkdir -p "$RIME_DIR"
            cp -r /usr/share/rime-ice/* "$RIME_DIR"
            echo "已从本地内置数据安装"
            ;;
        update)
            rm -rf "$HOME/.config/fcitx5/rime" "$RIME_DIR"
            mkdir -p "$RIME_DIR"
            TMP_DIR=$(mktemp -d)
            git clone https://github.com/rime/plum.git "$TMP_DIR/plum"
            cd "$TMP_DIR/plum"
            rime_dir="$RIME_DIR" bash rime-install iDvel/rime-ice
            rime_dir="$RIME_DIR" bash rime-install iDvel/rime-ice:others/recipes/grammar:schema=rime_ice
            rm -rf "$TMP_DIR"
            echo "已更新"
            ;;
    esac
    pgrep -x fcitx5 > /dev/null && fcitx5-remote -r || echo "fcitx5 not running, run 'fcitx5-remote -r' later"
