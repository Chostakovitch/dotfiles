#!/bin/sh

# Dependencies : jq ; udisks2
# Some updates by Quentin Duchemin on 18/03/07
# - Add label in lsblk selection
# - Add symbols from Material Google font
# - Remove term emulator opening and unused parts
# - Remove udiskctl power-off because we cannot mount again the removable device
# - Change printed name from vendor of the device to partition name (arbitrary choice)
# On 18/11/20
# - Change jq rm == '1' to rm == true
usb_print() {
    devices=$(lsblk -Jplno NAME,TYPE,RM,SIZE,MOUNTPOINT,VENDOR,LABEL)
    output=""
    counter=0

    for unmounted in $(echo "$devices" | jq -r '.blockdevices[]  | select(.type == 
"part") | select(.rm == true) | select(.mountpoint == null) | .name'); do
        unmounted=$(echo "$devices" | jq -r '.blockdevices[]  | select(.name == "'"$unmounted"'") | .label')
        unmounted=$(echo "$unmounted" | tr -d ' ')

        if [ $counter -eq 0 ]; then
            space=""
        else
            space="   "
        fi
        counter=$((counter + 1))

        output="$output$space $unmounted"
    done

    for mounted in $(echo "$devices" | jq -r '.blockdevices[] | select(.type == 
"part") | select(.rm == true) | select(.mountpoint != null) | .size'); do
        if [ $counter -eq 0 ]; then
            space=""
        else
            space="   "
        fi
        counter=$((counter + 1))

        output="$output$space $mounted"
    done

    echo "%{F#ddd}$output"
}

usb_update() {
    pid=$(pgrep -xf "/bin/sh /home/user/.config/scripts/polybar/system-usb-udev.sh")

    if [ "$pid" != "" ]; then
        kill -10 "$pid"
    fi
}

case "$1" in
    --update)
        usb_update
        ;;
    --mount)
        devices=$(lsblk -Jplno NAME,TYPE,RM,MOUNTPOINT)

        for mount in $(echo "$devices" | jq -r '.blockdevices[]  | select(.type == 
"part") | select(.rm == true) | select(.mountpoint == null) | .name'); do
            mountpoint=$(udisksctl mount --no-user-interaction -b "$mount")
        done

        usb_update
        ;;
    --unmount)
        devices=$(lsblk -Jplno NAME,TYPE,RM,MOUNTPOINT)

        for unmount in $(echo "$devices" | jq -r '.blockdevices[]  | select(.type == 
"part") | select(.rm == true) | select(.mountpoint != null) | .name'); do
            udisksctl unmount --no-user-interaction -b "$unmount"
            #power-off makes us unable to mount again...
            #udisksctl power-off --no-user-interaction -b "$unmount"
        done

        usb_update
        ;;
    *)
        trap exit INT
        trap "echo" USR1

        while true; do
            usb_print

            sleep 1 &
            wait
        done
        ;;
esac
