# Simple Openwrt Failover Script

### How to install?
1. Download .zip files
1. Extract .zip file in  /tmp folder
1. Move files in www folder to /www folder
``` mv www/ /www/ ```
1. Move folder failover to /etc/
``` mv failover /etc/failover/ ```

### How to configure script?
1. Edit **failover.sh**

### How to start script?
1. configure your cronjob file
```
*/2 * * * * /etc/failover/failover.sh
```
