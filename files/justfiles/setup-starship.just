setup-starship:
    #!/usr/bin/env bash
    # 在 ~/.bashrc 启用/禁用 starship 提示符 (方向键上下选择，回车确认)
    set -euo pipefail
    RC="$HOME/.bashrc"
    LINE='eval "$(starship init bash)"'
    GREEN=$'\033[1;32m'
    NC=$'\033[0m'

    if grep -qF 'starship init' "$RC" 2>/dev/null; then
        current=enable
    else
        current=disable
    fi

    options=(enable disable cancel)
    sel=0
    for i in "${!options[@]}"; do
        [ "${options[$i]}" = "$current" ] && sel=$i
    done

    n=0
    while true; do
        if [ "$n" -gt 0 ]; then printf '\033[4A\033[0J'; fi
        for i in "${!options[@]}"; do
            if [ "$i" -eq "$sel" ]; then
                printf '%b> %s%b\n' "$GREEN" "${options[$i]}" "$NC"
            else
                printf '  %s\n' "${options[$i]}"
            fi
        done
        printf '\033[90m%s\033[0m\n' '↑/↓ select，enter confirm'
        n=1
        read -r -s -n 1 key
        case "$key" in
            $'\e')
                read -r -s -n 2 -t 0.1 seq || true
                if [ "$seq" = '[A' ]; then
                    sel=$(( (sel - 1 + ${#options[@]}) % ${#options[@]} ))
                elif [ "$seq" = '[B' ]; then
                    sel=$(( (sel + 1) % ${#options[@]} ))
                fi
                ;;
            '') break ;;
        esac
    done

    case "${options[$sel]}" in
        cancel)
            echo "cancel"
            ;;
        enable)
            if grep -qFx 'eval "$(starship init bash)"' "$RC"; then
                echo "already enabled, skipped"
            else
                sed -i \
                    -e '/^# starship prompt$/d' \
                    -e '/^eval "$(starship init bash)"$/d' \
                    "$RC"

                printf '\n# starship prompt\n%s\n' "$LINE" >> "$RC"

                echo "enable starship, reopen terminal"
            fi
            ;;
        disable)
            sed -i \
                -e '/^# starship prompt$/d' \
                -e '/^eval "$(starship init bash)"$/d' \
                "$RC"

            echo "disable starship, reopen terminal"
            ;;
    esac
