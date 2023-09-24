set width 0
set height 0
set verbose off
target extended-remote /dev/serial/by-id/usb-Black_Magic_Debug_Black_Magic_Probe_...-if00
monitor swdp_scan
attach 1
dump memory flash0.bin 0x00000000 0x00040000
dump memory flash1.bin 0x0fe00000 0x0fe00800
dump memory flash2.bin 0x0fe10000 0x0fe12800
quit
