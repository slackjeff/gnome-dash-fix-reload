# gnome-dash-fix-reload

Organizes applications in the GNOME Shell App Grid by creating folders and assigning applications according to the FreeDesktop category standard.

This project was inspired by [gnome-dash-fix](https://github.com/BenJetson/gnome-dash-fix) and extends the idea with improved application detection, including support for Flatpak applications.

**Tested on:** GNOME 50

## Features

* Automatically creates GNOME application folders
* Organizes applications using FreeDesktop categories
* Supports System packages (RPM, DEB, Arch packages, etc.) and Flatpak applications
* Works with modern GNOME versions
* Provides an easy way to restore the default GNOME layout

## Result

![result](https://raw.githubusercontent.com/slackjeff/gnome-dash-fix-reload/refs/heads/main/img/result.png)

## Usage

1. Clone or download this repository:

```bash
git clone https://github.com/slackjeff/gnome-dash-fix-reload.git
cd gnome-dash-fix-reload
```

2. Make the script executable:

```bash
chmod +x gnome-dash-fix-reload.sh
```

3. Apply the GNOME folders configuration:

```bash
./gnome-dash-fix-reload.sh -a
```

For automatic folder creation and application assignment:

```bash
./gnome-dash-fix-reload.sh -aa
```

To restore the default GNOME layout:

```bash
./gnome-dash-fix-reload.sh -r
```

## Requirements

* GNOME Shell
* `gsettings`
* Applications with valid FreeDesktop `.desktop` metadata
