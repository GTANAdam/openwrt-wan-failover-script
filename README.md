# Simple Openwrt Failover Script

### How to install?
1. Download _.zip_ files
	> ``` wget https://github.com/rafinhaa/openwrt-wan-failover-script/zipvall/master/ ```
2. Extract _.zip_ file in  **/tmp** folder
	> ```cd /tmp```	
	> ``` unzip rafinhaa-openwrt-wan-failover-script-*.zip ```
4. Move files in **www** folder to **/www** folder
	> ``` mv www/ /www/ ```
5. Move folder **failover** to **/etc/**
	> ``` mv failover /etc/failover/ ```

### How to configure script?
1. Edit **failover.sh**
	> ``` vi /etc/failover/failover.sh ```
1. Edit variables between comments **_# Begin Configuration #_** and **_# Begin Configuration #_**

### How to start script?
1. Configure your crontab file
	> ``` */2 * * * * /etc/failover/failover.sh ```
1. Restart crontab service
	> ``` /etc/init.d/cron reload ```
