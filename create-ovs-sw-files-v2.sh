#! /bin/bash

# Usage
# sudo ./create-ovs-sw-files.sh ContainerBaseName ContainerCount

# Example
# sudo ./create-ovs-sw-files.sh lxcora0 6
# Above example would create networking files for 6 LXC containers with names of the form {lxcora01, lxcora02, lxcora03,lxcora04 lxcora05,lxcora06} 

# Notes
# The ContainerBaseName must be passed in at the command line and is the prefix of the LXC container names
# The ContainerCount is the total number of LXC containers to be created
# Run this script in the directory where the ovs files are located (e.g. /etc/network/if-up.d/openvswitch)
 
export DirectoryName='/etc/network/if-up.d/openvswitch /etc/network/if-down.d/openvswitch'
export ContainerBaseName=$1
export ContainerCount=$2

for j in $DirectoryName
do
cd $j

function GetFileNames {
ls "$ContainerBaseName"00* | more | grep "$1" | sed 's/$/ /' | tr -d '\n'
}

FileNames=$(GetFileNames)
OffsetContainerCount=$((ContainerCount+10))
echo $OffsetContainerCount
sleep 1

let n=10
	for i in $FileNames
	do
		while [ $n -le $OffsetContainerCount ]
		do
		echo $i
		sleep 1
		function NewFileNames {
		echo $i | sed "s/$ContainerBaseName/$ContainerBaseName$n/" | sed 's/00//'
		}
		NewFile=$(NewFileNames)
		echo "OldFile = $i"
		echo "NewFile = $NewFile"
		cp $i $NewFile
		((n=n+1))
		echo "n = $n"
		echo '---'
		done
	let n=10
	done
done

chmod 755 /etc/network/if-up.d/openvswitch/lxc*
chmod 755 /etc/network/if-down.d/openvswitch/lxc*