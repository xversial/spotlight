# Spotlight
Windows 10 Spotlight Screensaver and Background images for Gnome

## Installation
### System-wide
* /usr/bin/spotlight.sh
* /usr/lib/systemd/user/spotlight.service
* /usr/lib/systemd/user/spotlight.timer
* /usr/share/applications/spotlight.desktop
### Local
* ~/.local/bin/spotlight.sh
* ~/.local/share/systemd/user/spotlight.service
* ~/.local/share/systemd/user/spotlight.timer
* ~/.local/share/applications/spotlight.desktop
### Dependencies
* wget
* jq
* sed
* glib2 (gnome)
* systemd

## Usage
Run `systemctl --user enable spotlight.timer` to get a new picture every day.

To fetch a new background manually you can either use the desktop entry by looking for _spotlight_ in your gnome application menu (`[SUPER] spot... [ENTER]`) or trigger the service from command line with `systemctl --user start spotlight.service`.

Use the system log to get the past image descriptions, e.g. for the the current background `journalctl -t spotlight -n 1`.

## Configuration

Spotlight does not require particular configuration.

The default behavior of spotlight is to discard the previous image when it fetches a new one. This behavior can be alter from the command line:

 * -h shows a help message
 * -k keeps the previous image
 * -d stores the image into the given destination. Defaults to "$HOME/.local/share/backgrounds".

### Service

In order to modify the behavior of the service `systemctl edit --user spotlight.service` can be used to overwrite the program invocation:

```
[Service]
ExecStart=
ExecStart=/usr/bin/env bash spotlight.sh -k -d %h/Pictures/Spotlight
```

### Notifications

Notifications can be controlled via the Gnome Control Center.

## Packages
### Arch Linux
[aur/spotlight](https://aur.archlinux.org/packages/spotlight/)

## Installation

1. Install dependancies: 
This script depends on jq binary. You need to install it before launching the script:
    ```bash
    # Fedora
    sudo dnf install jq
    # Ubuntu and Debian
    sudo apt-get install jq
    # Centos
    sudo yum install jq
    ```

2. Clone the projet:
    ```bash
    sudo git clone https://github.com/remyj38/spotlight.git /opt/spotlight
    ```
3. Create links for scripts:
    ```bash
    sudo ln -s /opt/spotlight/spotlight.{service,timer} /etc/systemd/system/
    sudo ln -s /opt/spotlight/spotlight.sh /usr/bin/
    ```
4. Change the target user in the `spotlight.service` file
5. Enable and start the timer:
    ```bash
    sudo systemctl daemon-reload
    sudo systemctl enable spotlight.timer
    sudo systemctl start spotlight.service
    ```
6. Enable the screensaver image:
    ```bash
    gsettings set org.gnome.desktop.screensaver picture-options "zoom"
    gsettings set org.gnome.desktop.screensaver picture-uri "file://$HOME/.spotlight/.screensaver.jpg"
    ```
7. Enable the background image:
    ```bash
    gsettings set org.gnome.desktop.background picture-uri "file://$HOME/.spotlight/.background.jpg"
    gsettings set org.gnome.desktop.background picture-options "zoom"
    ```
