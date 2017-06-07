#!/bin/bash
#set -x
name="NAME"
nic=($name)
mac=("MAC")
pci=("PCI")
numa_node=("Node")
ip=("IP")
state=("State")
mtu=("MTU")
driver=("Driver")
speed=("Speed")
master=("Master")
IFS=$'\n'

#Retrieve all network interfaces
nic+=($(ip a  | grep ^[0-9]*:  | awk '{print $2 '} | sed -e 's/://' ))

function no_installed()
{
    echo ""
    echo -n "Missing $tool ... " 
    tools_installed=false
}
#Check tools
echo -n "Checking installed tools ... "
tools_installed=true
for tool in ethtool ip  
do
    which $tool > /dev/null  || no_installed 
done

if [ $tools_installed != true ]; then
    echo "" 
    exit 1
fi
echo Ok !

ACTION=":"

if [ $# -eq 1 ]; then
    if [ "$1" == "up" -o "$1" == "down" ]; then
        ACTION="ip link set $1 dev"
    fi
fi

for i in ${nic[@]}
do
    i=$(echo $i | sed 's/@[^ ]*//')
    #i=${i%%@NONE}
    if [ $i != $name ]; then
        IFS=' '
        $ACTION $i
        IFS=$'\n'

        mac_res=$(ip l sh $i | grep link/ether  | awk '{print $2 }')
        mac+=(${mac_res:-"x"})
        speed_res=$(ethtool $i | grep Speed | awk '{print $2}')
        speed+=(${speed_res:-"x"})
        pci_res=$(ethtool -i $i 2> /dev/null| grep bus-info | awk '{ print $2}' )
        pci+=(${pci_res:-"x"})
        if [  -n "${pci_res}" ] &&  [ "${pci_res}" != "tap" ] &&  [ "${pci_res}" != "N/A" ]; then
            numa_node+=($(cat /sys/bus/pci/devices/${pci_res}/numa_node))
        else
            numa_node+=("x")
        fi
        ip_res=($(ip a sh $i | grep net\  | awk '{ print $2}'))
        ip+=(${ip_res:-"x"})
        driver_res=$(ethtool -i $i 2> /dev/null| grep driver | awk '{ print $2}'  )
        driver+=(${driver_res:-"x"})
        nocarrier=$(ip l sh $i | grep ^[0-9] | awk '{ print $3}' | awk -F ',' '{ print $1}' | sed 's/<//')
        state+=($( if [ $nocarrier == "NO-CARRIER" ] ; then echo $nocarrier; else  ip l sh $i | grep ^[0-9] | awk '{ for (x=1;x<=NF;x++) if ($x~"state") print $(x+1) }'; fi))
        has_master=$(ip l sh $i | grep ^[0-9] | grep master)
        master+=($( if [ -z "${has_master}" ] ; then echo 'x'; else  ip l sh $i | grep ^[0-9] | awk '{ for (x=1;x<=NF;x++) if ($x~"master") print $(x+1) }'; fi))
        mtu+=($(ip l sh $i | grep ^[0-9] | awk '{ for (x=1;x<=NF;x++) if ($x~"mtu") print $(x+1) }'))
    fi
done


for i in $(seq 0 $((${#nic[@]}-1)))
do
        printf "| %-15s | %-10s | %-5s | %-17s | %-12s | %-4s | %-18s | %-14s | %-9s | %-12s |\n" ${nic[$i]} ${state[$i]} ${mtu[$i]} ${mac[$i]} ${pci[$i]} ${numa_node[$i]} ${ip[$i]} ${driver[$i]} ${speed[$i]} ${master[$i]}
done
