#!/bin/bash
#===================================================================#
# Author: Jefferson Carneiro <slackjeff@slackjeff.com.br>
# License: GPLv3
#
# GNOME Shell App Folder Organizer
# Uses FreeDesktop categories.
#===================================================================#

set -e

#================================#
# Global
#================================#

SCHEMA="org.gnome.desktop.app-folders"
BASE_PATH="/org/gnome/desktop/app-folders/folders"


#================================#
# Folder configuration
#================================#

folders=(
    "accessories"
    "games"
    "graphics"
    "internet"
    "office"
    "development"
    "science"
    "sound---video"
    "system-tools"
    "universal-access"
)


declare -A categories=(
    ["accessories"]="Utility"
    ["games"]="Game"
    ["graphics"]="Graphics"
    ["internet"]="Network"
    ["office"]="Office"
    ["development"]="Development"
    ["science"]="Science"
    ["sound---video"]="AudioVideo"
    ["system-tools"]="System"
    ["universal-access"]="Accessibility"
)


declare -A names=(
    ["accessories"]="Accessories"
    ["games"]="Games"
    ["graphics"]="Graphics"
    ["internet"]="Internet"
    ["office"]="Office"
    ["development"]="Development"
    ["science"]="Science"
    ["sound---video"]="Sound & Video"
    ["system-tools"]="System Tools"
    ["universal-access"]="Universal Access"
)


#================================#
# Functions
#================================#

HELP()
{
    cat <<EOF

Usage:

  $0 -a       Create folders
  $0 -aa      Create folders + assign applications
  $0 -r       Remove folders

EOF
    exit 0
}


GET_APPS()
{
    local category="$1"
    local apps=()

    local dirs=(
        "/usr/share/applications"
        "/var/lib/flatpak/exports/share/applications"
        "$HOME/.local/share/flatpak/exports/share/applications"
        "$HOME/.local/share/applications"
    )

    for dir in "${dirs[@]}"; do

        [ -d "$dir" ] || continue

        while IFS= read -r file; do

            if grep -q "^Categories=.*${category};" "$file"; then
                apps+=("$(basename "$file")")
            fi

        done < <(find "$dir" -name "*.desktop" 2>/dev/null)

    done


    if [ "${#apps[@]}" -gt 0 ]; then
        printf "["
        printf '"%s",' "${apps[@]}" | sed 's/,$//'
        printf "]"
    else
        printf "[]"
    fi
}

CREATE_FOLDER()
{
    local folder="$1"
    local name="$2"
    local category="$3"

    local path="$SCHEMA.folder:$BASE_PATH/$folder/"

    apps=$(GET_APPS "$category")


    echo "Creating: $name"

    gsettings set "$path" name "$name"

    gsettings set "$path" categories "['$category']"

    gsettings set "$path" apps "$apps"
}


APPLY_FOLDERS()
{
    folders_list=$(printf "'%s'," "${folders[@]}")
    folders_list="[${folders_list%,}]"

    gsettings set \
        "$SCHEMA" \
        folder-children \
        "$folders_list"

    echo "Folders enabled."
}


AUTO_APPLY()
{
    for folder in "${folders[@]}"; do

        CREATE_FOLDER \
            "$folder" \
            "${names[$folder]}" \
            "${categories[$folder]}"

    done


    APPLY_FOLDERS

    echo
    echo "GNOME folders configured successfully."
}


REVERT()
{
    gsettings reset \
        "$SCHEMA" \
        folder-children

    echo "Folders removed."
}


#================================#
# Main
#================================#

case "$1" in

    -a|apply)
        APPLY_FOLDERS
        ;;

    -aa|auto-apply)
        AUTO_APPLY
        ;;

    -r|revert)
        REVERT
        ;;

    *)
        HELP
        ;;
esac

# Reload
gsettings reset org.gnome.shell app-picker-layout
