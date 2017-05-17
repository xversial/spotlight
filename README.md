# Spotlight
Windows 10 Spotlight Screensaver images for Gnome

##Installation

1. Clone the projet:
```bash
sudo git clone https://github.com/remyj38/spotlight.git /opt/spotlight
```
2. Create links for scripts:
```bash
sudo ln -s /opt/spotlight/spotlight.{service,timer} /etc/systemd/system/
sudo ln -s /opt/spotlight/spotlight.sh /usr/bin/
```
3. Change the target user in the `spotlight.service` file
4. Enable and start the service and the timer:
```bash
sudo systemctl deamon-reload
sudo systemctl enable spotlight.service spotlight.timer
sudo systemctl start spotlight.service
```

