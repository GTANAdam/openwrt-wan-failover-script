#!/bin/sh 

# Begin Configuration #
PACKETS=10
PACKETS_MEDIUM=3
WAIT=10
HOST="8.8.4.4"

WAN1Interface=eth1
WAN1=wan

WAN2Interface=wlan0
WAN2=wwan

LOG="/var/log/failover.log"
STATUS="/www/sconn"

MODE_PATH=/etc/failover/mode 
DISC_PATH=/etc/failover/disc
# End Configuration #

if [ -e $MODE_PATH ]; then
  MODE=`cat $MODE_PATH`
else
  touch $MODE_PATH
  echo "1" > $MODE_PATH
  MODE=`cat $MODE_PATH`
fi

if [ -e $DISC_PATH ]; then
  DISC=`cat $DISC_PATH`
else
  touch $DISC_PATH
  echo "0" > $DISC_PATH
  DISC=`cat $DISC_PATH`
fi

echo "`date`: Failover script started." >> $LOG

# Ping on WAN1 interface
RET=`ping -w $WAIT -c $PACKETS -I $WAN1Interface $HOST 2>/dev/null | awk '/packets received/ {print $4}'`

      #menor ou igual       e    maior ou igual
if [ "$RET" -le "$PACKETS" -a "$RET" -ge "$PACKETS_MEDIUM" ]; then # Check if packets don't arrive on WAN1 interface
  if [ "$MODE" = "2" ]; then # If Mode is set to WAN2 then switch to WAN1
  #ifdown $WAN2
    uci set network.$WAN2.metric='1'
    uci set network.$WAN1.metric='0'
    uci commit network
		/etc/init.d/network reload
    echo "1" > $MODE_PATH
    echo "`date`: Switched to Ethernet connection!" >> $LOG
    echo "connected" > $STATUS
  fi
else # If packets arrive on WAN1 interface
  if [ "$MODE" = "1" ]; then # If Mode is set to WAN1 then switch to WAN2
  #ifup $WAN2  
    uci set network.$WAN2.metric='0'
    uci set network.$WAN1.metric='1'
    uci commit network
		/etc/init.d/network reload
    echo "2" > $MODE_PATH
    echo "0" > $DISC_PATH
    echo "`date`: Switched to Wireless connection!" >> $LOG
    echo "failover" > $STATUS
  fi
          
  # Ping on WAN2 interface
  RET2=`ping -w $WAIT -c $PACKETS -I $WAN2Interface $HOST 2>/dev/null | awk '/packets received/ {print $4}'`
  if [ "$RET2" -ne "$PACKETS" ]; then # Check if packets don't arrive on WAN2 interface
    if [ "$DISC" = "0" ]; then # Check if connection is set to 'outage'
      echo "1" > $DISC_PATH
      echo "disconnected" > $STATUS
    fi
  else 
    if [ "$DISC" = "1" ]; then # Check if connection is not set to 'outage'
      echo "0" > $DISC_PATH
      echo "failover" > $STATUS
    fi
  fi
  # Re-up interface to avoid non-responsive gateway
  #ifconfig $WAN1Interface down 
  #ifconfig $WAN1Interface up
  sleep 10
fi