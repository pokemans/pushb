What is this
======
Quick and dirty bash script to push data from your local /dev/stdin to pushbullet.com using their open API

Installation
======
download
copy to somewhere in your path and chmod +x,
ie

`# curl https://raw.github.com/pokemans/pushb/master/pushb.sh > /usr/sbin/pushb`<br>
`# chmod +x /usr/sbin/pushb`

Setup
======
Run pushb with the `-c` flag to configure it

you'll need your api key, which you can get from your account settings page on pushbullet.com

pushb will display a list of devices and their pushbullet IDs, for example <br>
`id: ujzyj0WstgqdjzWIEVDzOK description: Google Chrome`<br>
`id: ujzyj0WstgqdjAiVsKnSTs description: HTC One`

You select the device that pushb will default to by entering it's ID at the prompt like so

`ID to use as default: ujzyj0WstgqdjAiVsKnSTs`

you can always change the default device by running<br>
`
pushb -d <new_default_device_id>
`

or temporarily send to another device withr `-n`:<br>
`
ls |pushb -n ujzyj0WstgqdjzWIEVDzOK
`
<br><br>
`pushb -l` will list all devices connected to your account

Usage
======
<br>
`-c : (re)configure`

`-l : list devices & their IDs then exit`

` -n <device_id> : push to device_id (ie "u1qSJddxeKwOGuGW")`

` -d <device_id> : set device_id as the default push device then exit`

` -f <format> : use  (note|link|address|list|file)`

` -t <title> : use`


