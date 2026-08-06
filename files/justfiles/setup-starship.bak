# Manage starship prompt in ~/.bashrc. Options: status | enable | disable
setup-starship ACTION="":
    #!/usr/bin/bash
    source /usr/lib/ujust/ujust.sh
    RC="$HOME/.bashrc"
    LINE='eval "$(starship init bash)"'
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

            printf '\n# starship prompt\n%s\n' "$LINE" >> "$RC"

            echo "Starship enabled, reopen terminal"
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
    OPTION="{{ ACTION }}"
    if [[ "$OPTION" == "help" ]]; then
        echo "Usage: ujust setup-starship <option>"
        echo "  <option>: Specify the quick option to skip the prompt"
        echo "  Use 'status' to print the current status token"
        echo "  Use 'enable' to enable starship in ~/.bashrc"
        echo "  Use 'disable' to disable starship in ~/.bashrc"
        exit 0
    elif [[ "$OPTION" == "status" ]]; then
        get_status_token
        exit $?
    elif [[ "$OPTION" == "enable" ]]; then
        enable_starship
        exit 0
    elif [[ "$OPTION" == "disable" ]]; then
        disable_starship
        exit 0
    elif [[ -z "$OPTION" ]]; then
        current_status=$(get_current_status)
        echo "${bold}Starship${normal}"
        echo "Current status: $current_status"
        OPTION=$(ugum choose "Enable" "Disable" "Exit without changes")
        case "$OPTION" in
            "Enable")
                enable_starship
                ;;
            "Disable")
                disable_starship
                ;;
            *)
                echo "No changes made."
                ;;
        esac
        exit 0
    fi
