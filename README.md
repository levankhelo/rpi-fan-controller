# rpi-fan-controller
simple controller for rpi 5 fan. 

Originally made to control fan via ssh for Homebridge.
i used "hacky" solution as i have rpi clusters, and added following configuration of `homebridge-Script2` plugin for Homebridge
```json
{
    "accessory": "Script2",
    "name": "RPI-1 Fan Mini",
    "on": "ssh homebridge@rpi.local /bin/bash -c 'bash /home/homebridge/.fan/controller.sh on'",
    "off": "ssh homebridge@rpi.local /bin/bash -c 'bash /home/homebridge/.fan/controller.sh off'",
    "state": "ssh homebridge@rpi.local /bin/bash -c 'bash /home/homebridge/.fan/controller.sh state'",
    "on_value": "true",
}
```
> make sure you do
> 1. `ssh-keygen` to generate ssh key
> 2. `ssh-copy-id homebrdige@rpi.local` to add your host to target as trusted device
> 3. `ssh homebrdige@rpi.local` after trusted host, you need to log in one last time
> This way, you will connect to your target rpi (which has fan installed) from host rpi, without using password.
