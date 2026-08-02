setup-niri:
    #!/usr/bin/env bash
    # 安装/备份/还原/清除备份 niri 定制配置 (方向键上下选择，回车确认)
    set -euo pipefail
    NIRI_DIR="$HOME/.config/niri"
    GREEN=$'\033[1;32m'
    NC=$'\033[0m'

    menu() {
        local -n _labels=$1 _values=$2
        local _sel=0 _n=0 _key _seq _lines
        _lines=$(( ${#_labels[@]} + 1 ))
        while true; do
            if [ "$_n" -gt 0 ]; then printf '\033[%sA\033[0J' "$_lines" >&2; fi
            for i in "${!_labels[@]}"; do
                if [ "$i" -eq "$_sel" ]; then
                    printf '%b> %s%b\n' "$GREEN" "${_labels[$i]}" "$NC" >&2
                else
                    printf '  %s\n' "${_labels[$i]}" >&2
                fi
            done
            printf '\033[90m%s\033[0m\n' '↑/↓ 选择，回车确认' >&2
            _n=1
            read -r -s -n 1 _key
            case "$_key" in
                $'\e')
                    read -r -s -n 2 -t 0.1 _seq || true
                    if [ "$_seq" = '[A' ]; then
                        _sel=$(( (_sel - 1 + ${#_labels[@]}) % ${#_labels[@]} ))
                    elif [ "$_seq" = '[B' ]; then
                        _sel=$(( (_sel + 1) % ${#_labels[@]} ))
                    fi
                    ;;
                '') break ;;
            esac
        done
        printf '%s\n' "$_sel"
    }

    labels=(安装 备份 还原 清除备份 取消)
    values=(install backup restore clear cancel)

    printf '\033[?1049h'
    trap 'printf "\033[?1049l"' EXIT
    result=""
    while true; do
        clear
        echo "Niri 配置（~/.config/niri）"
        sel=$(menu labels values)
        case "${values[$sel]}" in
            cancel)
                result="cancel"
                break
                ;;
            backup)
                if [ -d "$NIRI_DIR" ]; then
                    BK="$NIRI_DIR.bak.$(date +%Y%m%d-%H%M%S)"
                    cp -r "$NIRI_DIR" "$BK"
                    result="已备份到 $BK"
                else
                    result="没有现有配置可备份"
                fi
                break
                ;;
            install)
                if [ -d "$NIRI_DIR" ]; then
                    BK="$NIRI_DIR.bak.$(date +%Y%m%d-%H%M%S)"
                    cp -r "$NIRI_DIR" "$BK"
                fi
                mkdir -p "$NIRI_DIR"
                cp -r /usr/share/niri-config/* "$NIRI_DIR"
                result="已安装镜像内置配置"
                niri msg action load-config-file 2>/dev/null || true
                break
                ;;
            restore)
                mapfile -t bks < <(find "$HOME/.config" -maxdepth 1 -type d -name 'niri.bak.*' | sort)
                if [ "${#bks[@]}" -eq 0 ]; then
                    read -r -s -n 1 -p "没有找到备份，按任意键返回主菜单" _ || true
                    echo
                    continue
                fi
                rlabels=()
                rvalues=()
                for b in "${bks[@]}"; do
                    rlabels+=("${b##*/}")
                    rvalues+=("$b")
                done
                rlabels+=("取消")
                rvalues+=("cancel")
                rsel=$(menu rlabels rvalues)
                if [ "${rvalues[$rsel]}" != "cancel" ]; then
                    cp -r "${rvalues[$rsel]}/." "$NIRI_DIR/"
                    result="已还原 ${rvalues[$rsel]}"
                    niri msg action load-config-file 2>/dev/null || true
                else
                    result="cancel"
                fi
                break
                ;;
            clear)
                mapfile -t bks < <(find "$HOME/.config" -maxdepth 1 -type d -name 'niri.bak.*' | sort)
                if [ "${#bks[@]}" -eq 0 ]; then
                    read -r -s -n 1 -p "没有找到备份，按任意键返回主菜单" _ || true
                    echo
                    continue
                fi
                echo "将删除以下 ${#bks[@]} 个备份："
                printf '  %s\n' "${bks[@]}"
                read -r -p "确认删除？[y/N] " ans
                case "$ans" in
                    [yY]|[yY][eE][sS])
                        rm -rf "${bks[@]}"
                        result="已删除 ${#bks[@]} 个备份："
                        for b in "${bks[@]}"; do
                            result+=$'\n  '"$b"
                        done
                        ;;
                    *) result="已取消" ;;
                esac
                break
                ;;
        esac
    done
    printf '\033[?1049l'
    if [ -n "$result" ]; then
        printf '\n%s\n' "$result"
    fi
