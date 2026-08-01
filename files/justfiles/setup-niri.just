setup-niri:
    #!/usr/bin/env bash
    # 安装/备份/还原 niri 定制配置 (方向键上下选择，回车确认)
    set -euo pipefail
    NIRI_DIR="$HOME/.config/niri"
    GREEN=$'\033[1;32m'
    NC=$'\033[0m'

    menu() {
        local -n _labels=$1 _values=$2
        local _sel=0 _n=0 _key _seq _lines
        _lines=$(( ${#_labels[@]} + 1 ))
        while true; do
            if [ "$_n" -gt 0 ]; then printf '\033[%sA\033[0J' "$_lines"; fi
            for i in "${!_labels[@]}"; do
                if [ "$i" -eq "$_sel" ]; then
                    printf '%b> %s%b\n' "$GREEN" "${_labels[$i]}" "$NC"
                else
                    printf '  %s\n' "${_labels[$i]}"
                fi
            done
            printf '\033[90m%s\033[0m\n' '↑/↓ 选择，回车确认'
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

    labels=(安装 备份 还原 取消)
    values=(install backup restore cancel)
    sel=$(menu labels values)
    case "${values[$sel]}" in
        cancel)
            echo "cancel"
            ;;
        backup)
            if [ -d "$NIRI_DIR" ]; then
                BK="$NIRI_DIR.bak.$(date +%Y%m%d-%H%M%S)"
                cp -r "$NIRI_DIR" "$BK"
                echo "已备份到 $BK"
            else
                echo "没有现有配置可备份"
            fi
            ;;
        install)
            if [ -d "$NIRI_DIR" ]; then
                BK="$NIRI_DIR.bak.$(date +%Y%m%d-%H%M%S)"
                cp -r "$NIRI_DIR" "$BK"
                echo "已备份现有配置到 $BK"
            fi
            mkdir -p "$NIRI_DIR"
            cp -r /usr/share/niri-config/* "$NIRI_DIR"
            echo "已安装镜像内置配置"
            niri msg action load-config-file 2>/dev/null || true
            ;;
        restore)
            mapfile -t bks < <(find "$HOME/.config" -maxdepth 1 -type d -name 'niri.bak.*' | sort)
            if [ "${#bks[@]}" -eq 0 ]; then
                echo "没有找到备份"
            else
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
                    echo "已还原 ${rvalues[$rsel]}"
                    niri msg action load-config-file 2>/dev/null || true
                fi
            fi
            ;;
    esac
