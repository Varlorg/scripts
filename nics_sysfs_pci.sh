#!/bin/bash
# List network info based on pci info

#set -x
name="NAME"
nic=($name)
mac=("MAC")
pci=("PCI")
numa_node=("Node")
ip=("IP")
state=("Carrier")
mtu=("MTU")
driver=("Driver")
speed=("Speed")
sriov=("SRIOV")
IFS=$'\n'

function no_installed() {
	echo ""
	echo -n "Missing $tool ... "
	tools_installed=false
}
#Check tools
echo -n "Checking installed tools ... "
tools_installed=true
for tool in lspci; do
	which $tool >/dev/null || no_installed
done

if [ $tools_installed != true ]; then
	echo ""
	exit 1
fi
echo Ok !

#Retrieve all network interfaces
nic+=($(lspci | grep Eth | awk '{ print $1 }'))
#nic+=($( lspci | grep Eth | awk '{ print $1 }' | sed 's/:/\\&/'))

# without lspci tools : grep PCI_SLOT_NAME /sys/class/net/*/device/uevent | awk -F= '{print $2}'

ACTION=":"

if [ $# -eq 1 ]; then
	if [ "$1" == "up" -o "$1" == "down" ]; then
		ACTION="ip link set $1 dev"
	fi
fi

for i in ${nic[@]}; do
	i=$(echo "0000:$i" | sed 's/@[^ ]*//')
	#i=${i%%@NONE}
	if [ $i != 0000:$name ]; then
		IFS=' '
		$ACTION $i
		IFS=$'\n'
		pci+=($i)
		mac_find=$(find /sys/bus/pci/devices/$i/ -name address)
		[ -n "${mac_find}" ] && mac_res=$(cat ${mac_find})
		mac+=(${mac_res:-"x"})
		unset mac_find
		unset mac_res

		mtu_find=$(find /sys/bus/pci/devices/$i/ -name mtu)
		[ -n "${mtu_find}" ] && mtu_res=$(cat ${mtu_find})
		mtu+=(${mtu_res:-"x"})
		unset mtu_find
		unset mtu_res

		speed_find=$(find /sys/bus/pci/devices/$i/ -name speed)
		[ -n "${speed_find}" ] && speed_res=$(cat ${speed_find})
		speed+=(${speed_res:-"x"})
		unset speed_find
		unset speed_res

		numa_node_find=$(find /sys/bus/pci/devices/$i/ -name numa_node)
		[ -n "${numa_node_find}" ] && numa_node_res=$(cat ${numa_node_find})
		numa_node+=(${numa_node_res:-"x"})
		unset numa_node_find
		unset numa_node_res

		carrier_find=$(find /sys/bus/pci/devices/$i/ -name carrier)
		[ -n "${carrier_find}" ] && carrier_res=$(cat ${carrier_find})
		state+=(${carrier_res:-"x"})
		unset carrier_find
		unset carrier_res

		sriov_num_find=$(find /sys/bus/pci/devices/$i/ -name sriov_numvfs)
		sriov_max_find=$(find /sys/bus/pci/devices/$i/ -name sriov_totalvfs)
		[ -n "${sriov_num_find}" ] && sriov_res=$(echo "$(cat ${sriov_num_find})/$(cat ${sriov_max_find})")
		sriov+=(${sriov_res:-"x"})
		unset sriov_find
		unset sriov_res

		driver_res=$(basename $(readlink -f /sys/bus/pci/devices/$i/driver))
		driver+=(${driver_res:-"x"})
	fi
done

for i in $(seq 0 $((${#nic[@]} - 1))); do
	printf "| %-15s | %-10s | %-5s | %-17s | %-12s | %-4s | %-14s | %-9s | %-12s |\n" ${nic[$i]} ${state[$i]} ${mtu[$i]} ${mac[$i]} ${pci[$i]} ${numa_node[$i]} ${driver[$i]} ${speed[$i]} ${sriov[$i]}
done
