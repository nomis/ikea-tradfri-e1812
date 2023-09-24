set width 0
set height 0
set verbose off
target extended-remote /dev/serial/by-id/usb-Black_Magic_Debug_Black_Magic_Probe_...-if00
monitor swdp_scan
attach 1
load firmware.elf 0
quit
