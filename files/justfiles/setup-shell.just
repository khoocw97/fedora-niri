# Manage starship prompt and zoxide in ~/.bashrc. Options: status | enable | disable
setup-shell ACTION="":
    #!/usr/bin/bash
    source /usr/lib/ujust/ujust.sh
    RC="$HOME/.bashrc"
    STARSHIP_LINE='eval "$(starship init bash)"'
    ZOXIDE_LINE='eval "$(zoxide init bash)"'
    get_status_token() {
        if grep -qF 'starship init' "$RC" 2>/dev/null; then
            echo "enable"
        else
            echo "disable"
        fi
    }
    get_current_status() {
        if [[ "$(get_status_token)" == "enable" ]]; then
            echo "Enabled"
        else
            echo "Not Enabled"
        fi
    }
    enable_starship() {
        echo "Enabling starship..."
        if grep -qFx 'eval "$(starship init bash)"' "$RC"; then
            echo "Already enabled, skipped"
        else
            sed -i \
                -e '/^# starship prompt$/d' \
                -e '/^eval "$(starship init bash)"$/d' \
                "$RC"

            printf '\n# starship prompt\n%s\n' "$STARSHIP_LINE" >> "$RC"

            echo "Starship enabled, reopen terminal"
        fi
    }
    enable_zoxide() {
        echo "Enabling zoxide..."
        if grep -qFx 'eval "$(zoxide init bash)"' "$RC"; then
            echo "Already enabled, skipped"
        else
            sed -i \
                -e '/^# zoxide init$/d' \
                -e '/^eval "$(zoxide init bash)"$/d' \
                "$RC"

            printf '\n# zoxide init\n%s\n' "$ZOXIDE_LINE" >> "$RC"

            echo "Zoxide enabled, reopen terminal"
        fi
    }
    disable_starship() {
        echo "Disabling starship..."
        sed -i \
            -e '/^# starship prompt$/d' \
            -e '/^eval "$(starship init bash)"$/d' \
            "$RC"

        echo "Starship disabled, reopen terminal"
    }
    disable_zoxide() {
        echo "Disabling zoxide..."
        sed -i \
            -e '/^# zoxide init$/d' \
            -e '/^eval "$(zoxide init bash)"$/d' \
            "$RC"

        echo "Zoxide disabled, reopen terminal"
    }
    ALIASES=(
        "alias ll='eza -l --icons=auto --group-directories-first'"
        "alias l.='eza -d .*'"
        "alias ls='eza'"
        "alias l1='eza -1'"
        "alias cat='bat --style=plain --pager=never'"
    )
    remove_line() {
        grep -Fxv -- "$1" "$RC" > "$RC.tmp" && mv "$RC.tmp" "$RC"
    }
    enable_aliases() {
        echo "Enabling eza & bat aliases..."
        if grep -qF 'alias ll=' "$RC"; then
            echo "Already enabled, skipped"
        else
            sed -i -e '/^# eza & bat aliases$/d' "$RC"
            for alias_line in "${ALIASES[@]}"; do
                remove_line "$alias_line"
            done

            printf '\n# eza & bat aliases\n' >> "$RC"
            for alias_line in "${ALIASES[@]}"; do
                printf '%s\n' "$alias_line" >> "$RC"
            done

            echo "Aliases enabled, reopen terminal"
        fi
    }
    disable_aliases() {
        echo "Disabling eza & bat aliases..."
        sed -i -e '/^# eza & bat aliases$/d' "$RC"
        for alias_line in "${ALIASES[@]}"; do
            remove_line "$alias_line"
        done

        echo "Aliases disabled, reopen terminal"
    }
    OPTION="{{ ACTION }}"
    if [[ "$OPTION" == "help" ]]; then
        echo "Usage: ujust setup-shell <option>"
        echo "  <option>: Specify the quick option to skip the prompt"
        echo "  Use 'status' to print the current status token"
        echo "  Use 'enable' to enable starship, zoxide and eza/bat aliases in ~/.bashrc"
        echo "  Use 'disable' to disable starship, zoxide and eza/bat aliases in ~/.bashrc"
        exit 0
    elif [[ "$OPTION" == "status" ]]; then
        get_status_token
        exit $?
    elif [[ "$OPTION" == "enable" ]]; then
        enable_starship
        enable_zoxide
        enable_aliases
        exit 0
    elif [[ "$OPTION" == "disable" ]]; then
        disable_starship
        disable_zoxide
        disable_aliases
        exit 0
    elif [[ -z "$OPTION" ]]; then
        current_status=$(get_current_status)
        echo "${bold}Starship & Zoxide & Aliases${normal}"
        echo "Current status: $current_status"
        OPTION=$(ugum choose "Enable" "Disable" "Exit without changes")
        case "$OPTION" in
            "Enable")
                enable_starship
                enable_zoxide
                enable_aliases
                ;;
            "Disable")
                disable_starship
                disable_zoxide
                disable_aliases
                ;;
            *)
                echo "No changes made."
                ;;
        esac
        exit 0
    fi
