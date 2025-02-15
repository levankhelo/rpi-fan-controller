#!/bin/bash

# Fan control script
# Usage: ./fan_control.sh {on|off|auto}

# Fan control command for the official fan PWM pin
FAN_ON="sudo pinctrl FAN_PWM op dl"
FAN_OFF="sudo pinctrl FAN_PWM op dh"
SRC_DIR="/home/homebridge/.fan"
STATE_PATH="$SRC_DIR/state"

# Function to turn the fan on
fan_on() {
    echo "Turning fan ON..."
    $FAN_ON
    echo "true" > $STATE_PATH
    chmod a+rwx $STATE_PATH
    chown homebridge:homebridge $STATE_PATH
}

# Function to turn the fan off
fan_off() {
    echo "Turning fan OFF..."
    $FAN_OFF
    rm -f $STATE_PATH
}

# Function to enable temperature-based automatic fan control
fan_auto() {
    echo "Enabling AUTO mode (temperature-dependent)..."
    while true; do
        # Read the current CPU temperature
        CPU_TEMP=$(cat /sys/class/thermal/thermal_zone0/temp)
        CPU_TEMP=$((CPU_TEMP / 1000)) # Convert to Celsius

        # Set temperature thresholds
        TEMP_ON=55  # Turn on fan at 55°C
        TEMP_OFF=45 # Turn off fan below 45°C

        if [ "$CPU_TEMP" -ge "$TEMP_ON" ]; then
            fan_on
        elif [ "$CPU_TEMP" -le "$TEMP_OFF" ]; then
            fan_off
        fi

        # Wait for 10 seconds before checking again
        sleep 10
    done
    echo "true" > $STATE_PATH
}

get_state() {
    if pinctrl FAN_PWM | grep -q "op dl"; then
        echo "true";
    else
	echo "false";
    fi
    exit 0;
}

# Main script
case "$1" in
    on)
        fan_on
        ;;
    off)
        fan_off
        ;;
    auto)
        fan_auto
        ;;
    state)
	get_state
	;;
    *)
        echo "Usage: $0 {on|off|auto|state}"
        exit 1
        ;;
esac
