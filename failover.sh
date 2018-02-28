#!/bin/sh 

INTERVAL=5
PACKETS=1
WAIT=3
HOST="8.8.4.4"
MODE=1;
DISC=0

WAN1Interface=eth0
WAN1=wan

WAN2Interface=wlan0
WAN2=wwan

LOG="/www/failover.log"
STATUS="/www/sconn"

echo "`date`: Failover script started." >> $LOG
while sleep $INTERVAL
do
    # Ping on WAN1 interface
    RET=`ping -w $WAIT -c $PACKETS -I $WAN1Interface $HOST 2>/dev/null | awk '/packets received/ {print $4}'` 

    if [ "$RET" -ne "$PACKETS" ]; then # Check if packets don't arrive on WAN1 interface
        if [ "$MODE" = "1" ]; then # If Mode is set to WAN1 then switch to WAN2
            #ifup $WAN2
            uci set network.$WAN2.metric='1'
            uci commit network
            MODE=2
            DISC=0
            echo "`date`: Switched to Wireless connection!" >> $LOG
            echo "failover" > $STATUS
        fi
        
        # Ping on WAN2 interface
        RET2=`ping -w $WAIT -c $PACKETS -I $WAN2Interface $HOST 2>/dev/null | awk '/packets received/ {print $4}'`

        if [ "$RET2" -ne "$PACKETS" ]; then # Check if packets don't arrive on WAN2 interface
            if [ "$DISC" = "0" ]; then # Check if connection is set to 'outage'
                DISC=1
                echo "disconnected" > $STATUS
            fi
       else 
            if [ "$DISC" = "1" ]; then # Check if connection is not set to 'outage'
                DISC=0
                echo "failover" > $STATUS
            fi
        fi

        # Re-up interface to avoid non-responsive gateway
        ifconfig $WAN1Interface down 
        ifconfig $WAN1Interface up
        sleep 10

    else # If packets arrive on WAN1 interface
        if [ "$MODE" = "2" ]; then # If Mode is set to WAN2 then switch to WAN1
            #ifdown $WAN2
            uci set network.$WAN2.metric='20'
            uci commit network
            MODE=1
            echo "`date`: Switched to Ethernet connection!" >> $LOG
            echo "connected" > $STATUS
        fi
    fi 
done;