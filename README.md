# Simple Openwrt Failover Script

### How to install?
1. Download __.zip__ files
1. Extract __.zip__ file in  **/tmp** folder
1. Move files in **www** folder to **/www** folder
1.1 ``` mv www/ /www/ ```
1. Move folder **failover** to **/etc/**
1.1 ``` mv failover /etc/failover/ ```

### How to configure script?
1. Edit **failover.sh**

### How to start script?
1. Configure your crontab file
1.1 ``` */2 * * * * /etc/failover/failover.sh ```
1. Restart crontab service
1.1 ``` /etc/init.d/cron reload ```
