#!/bin/bash
#===================================================================#
# Author: Jefferson Carneiro <slackjeff@slackjeff.com.br>
# License: GPLv3
#
# Organizes the applications in the GNOME Shell Dashboard into
# appropriate categories and following the FreeDesktop standard for
# categorization.
#===================================================================#
set -e

#================================#
# Global
#================================#
export default_folders=$(gsettings list-schemas | grep org.gnome.desktop.app-folders)

#================================#
# Set folders here
#================================#
# Define the folders to be used for organizing applications in GNOME.
# Each item in the list below represents an application category.
# These categories are used to group applications in the GNOME app dashboard
# (e.g., "Accessories", "Games", "Internet", etc.).
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

# Categories mapping for auto-apply functionality
declare -A categories
categories=(
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

#================================#
# Functions
#================================#
function HELP()
{
    echo "Usage:"
    echo " -a, apply  - Organizing applications to folders"
    echo " -r, revert - Revert to default"
    echo " -aa, auto-apply - Auto-apply with enhanced folder configuration"
    exit 0
}

function APPLY_FOLDERS()
{
    # Convert array to the correct format for gsettings
    folders_string=$(printf "'%s', " "${folders[@]}" | sed 's/, $//')

    # Apply to gsettings
    gsettings set $default_folders folder-children "[$folders_string]"
}

function AUTO_APPLY_FOLDERS()
{
    # Create and configure each folder
    for folder in "${folders[@]}"; do
        # Capitalize folder name for display
        display_name="$(tr '[:lower:]' '[:upper:]' <<< ${folder:0:1})${folder:1}"
        category=${categories[$folder]}

        # Set folder name
        gsettings set $default_folders.folder:/org/gnome/desktop/app-folders/folders/$folder/ name "$display_name"
        # Assign category to folder
        gsettings set $default_folders.folder:/org/gnome/desktop/app-folders/folders/$folder/ categories "['$category']"
    done

    # Apply all folders
    folders_string=$(printf "'%s', " "${folders[@]}" | sed 's/, $//')
    gsettings set $default_folders folder-children "[$folders_string]"

    echo "Auto-apply completed successfully!"
    echo "Folders configured with proper names and categories."
}

function REVERT_FOLDERS()
{
    # Revert
    gsettings reset "$default_folders" folder-children
}

case $1 in
    -a|apply) APPLY_FOLDERS     ;;
    -r|revert) REVERT_FOLDERS ;;
    -aa|auto-apply) AUTO_APPLY_FOLDERS ;;
    *) HELP ;;
esac