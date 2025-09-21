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

#================================#
# Functions
#================================#
function HELP()
{
    echo "Usage:"
    echo " -a, apply  - Organizing applications to folders"
    echo " -r, revert - Revert to default"
    exit 0
}

function APPLY_FOLDERS()
{
    # Convert array to the correct format for gsettings
    folders_string=$(printf "'%s', " "${folders[@]}" | sed 's/, $//')

    # Apply to gsettings
    gsettings set $default_folders folder-children "[$folders_string]"
}

function REVERT_FOLDERS()
{
    # Revert
    gsettings reset "$default_folders" folder-children
}

case $1 in
    -a|apply) APPLY_FOLDERS     ;;
    -r|revert) REVERT_FOLDERS ;;
    *) HELP ;;
esac