# Spotlight
Windows 10 Spotlight Screensaver images for Gnome

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
sudo systemctl deamon-reload
sudo systemctl enable spotlight.timer
sudo systemctl start spotlight.service
```
6. Enable the screensaver image:
```bash
gsettings set org.gnome.desktop.screensaver picture-options "zoom"
gsettings set org.gnome.desktop.screensaver picture-uri "file://$HOME/.spotlight/.screensaver.jpg"
    ```
