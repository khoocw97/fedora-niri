# 管理 niri 定制配置（安装/备份/还原/清除备份）。选项: status | install | backup | restore | clear
setup-niri ACTION="":
    #!/usr/bin/bash
    source /usr/lib/ujust/ujust.sh
    NIRI_DIR="$HOME/.config/niri"
    get_status_token() {
        if [ -d "$NIRI_DIR" ]; then
            echo "install"
        else
            echo "uninstall"
        fi
    }
    get_current_status() {
        if [[ "$(get_status_token)" == "install" ]]; then
            echo "已安装"
        else
            echo "未安装"
        fi
    }
    find_backups() {
        find "$HOME/.config" -maxdepth 1 -type d -name 'niri.bak.*' | sort
    }
    install_niri() {
        echo "安装 Niri 配置..."
        if [ -d "$NIRI_DIR" ]; then
            BK="$NIRI_DIR.bak.$(date +%Y%m%d-%H%M%S)"
            cp -r "$NIRI_DIR" "$BK"
            echo "已备份原配置到 $BK"
        fi
        mkdir -p "$NIRI_DIR"
        cp -r /usr/share/niri-config/* "$NIRI_DIR"
        echo "已安装镜像内置配置"
        niri msg action load-config-file 2>/dev/null || true
    }
    backup_niri() {
        echo "备份 Niri 配置..."
        if [ -d "$NIRI_DIR" ]; then
            BK="$NIRI_DIR.bak.$(date +%Y%m%d-%H%M%S)"
            cp -r "$NIRI_DIR" "$BK"
            echo "已备份到 $BK"
        else
            echo "没有现有配置可备份"
        fi
    }
    restore_niri() {
        echo "还原 Niri 配置..."
        mapfile -t bks < <(find_backups)
        if [ "${#bks[@]}" -eq 0 ]; then
            echo "没有找到备份"
            return 1
        fi
        if [ -d "$NIRI_DIR" ]; then
            BK="$NIRI_DIR.bak.$(date +%Y%m%d-%H%M%S)"
            cp -r "$NIRI_DIR" "$BK"
            echo "已备份当前配置到 $BK"
        fi
        labels=()
        values=()
        for b in "${bks[@]}"; do
            labels+=("${b##*/}")
            values+=("$b")
        done
        labels+=("取消")
        values+=("cancel")
        sel=$(ugum choose --selected "${labels[0]}" "${labels[@]}")
        [[ "$sel" == "取消" ]] && echo "已取消" && return 1
        for i in "${!labels[@]}"; do
            if [[ "${labels[$i]}" == "$sel" ]]; then
                cp -r "${values[$i]}/." "$NIRI_DIR/"
                echo "已还原 ${values[$i]}"
                niri msg action load-config-file 2>/dev/null || true
                return 0
            fi
        done
        echo "已取消"
        return 1
    }
    clear_niri() {
        echo "清除 Niri 配置备份..."
        mapfile -t bks < <(find_backups)
        if [ "${#bks[@]}" -eq 0 ]; then
            echo "没有找到备份"
            return 1
        fi
        echo "将删除以下 ${#bks[@]} 个备份："
        printf '  %s\n' "${bks[@]}"
        if ugum confirm "确认删除？"; then
            rm -rf "${bks[@]}"
            echo "已删除 ${#bks[@]} 个备份"
        else
            echo "已取消"
        fi
    }
    OPTION="{{ ACTION }}"
    if [[ "$OPTION" == "help" ]]; then
        echo "Usage: ujust setup-niri <option>"
        echo "  <option>: Specify the quick option to skip the prompt"
        echo "  Use 'status' to print the current status token"
        echo "  Use 'install' to install the built-in niri config"
        echo "  Use 'backup' to backup the current niri config"
        echo "  Use 'restore' to restore a niri config backup"
        echo "  Use 'clear' to clear all niri config backups"
        exit 0
    elif [[ "$OPTION" == "status" ]]; then
        get_status_token
        exit $?
    elif [[ "$OPTION" == "install" ]]; then
        install_niri
        exit 0
    elif [[ "$OPTION" == "backup" ]]; then
        backup_niri
        exit 0
    elif [[ "$OPTION" == "restore" ]]; then
        restore_niri
        exit 0
    elif [[ "$OPTION" == "clear" ]]; then
        clear_niri
        exit 0
    elif [[ -z "$OPTION" ]]; then
        current_status=$(get_current_status)
        echo "${bold}Niri 配置${normal}"
        echo "当前状态: $current_status"
        OPTION=$(ugum choose "安装" "备份" "还原" "清除备份" "退出不更改")
        case "$OPTION" in
            "安装")
                install_niri
                ;;
            "备份")
                backup_niri
                ;;
            "还原")
                restore_niri
                ;;
            "清除备份")
                clear_niri
                ;;
            *)
                echo "没有更改。"
                ;;
        esac
        exit 0
    fi
