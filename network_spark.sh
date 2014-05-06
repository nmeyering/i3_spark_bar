#!/bin/bash

if (( $# > 0 )); then
	interface="${1}"
else
	interface="eth0"
fi

if (( $# > 1 )); then
	i3statusconfig="${2}"
else
	i3statusconfig="${XDG_CONFIG_HOME}/i3status"
fi
echo "status config found: ${i3statusconfig}"

if (( $# > 2 )); then
	delay="${3}"
else
	delay=1
fi

function human_readable()
{
	local kilo=$( echo "scale=2; $1 / 1024" | bc )
	local kiloint=$( echo "$1 / 1024" | bc )

	local mega=$( echo "scale=2; $kilo / 1024" | bc )
	local megaint=$( echo "$kilo / 1024" | bc )

	local giga=$( echo "scale=2; $mega / 1024" | bc )
	local gigaint=$( echo "$mega / 1024" | bc )

	local format="%#3d"

	if [ $kiloint -lt 1 ] ; then
		printf "${format}  B/s" "$1"
	elif [ $megaint -lt 1 ] ; then
		printf "${format} KB/s" "$kiloint"
	elif [ $gigaint -lt 1 ] ; then
		printf "${format} MB/s" "$megaint"
	else
		printf "${format} GB/s" "$gigaint"
	fi
}

function get_traffic()
{
	grep "${1}" /proc/net/dev | sed "s/.*${1}:\s\+\([0-9]\+\).*/\1/"
}

traffic_old=$(get_traffic "${interface}")

values=(0 0 0 0 0 0 0 0 0 0)

max_length=10

i3status --config "${i3statusconfig}" | while read line
do
	traffic_new=$(get_traffic "${interface}")

	# difference between the last two measurements is the new value
	difference=$((${traffic_new} - ${traffic_old}))

	# append the new value to the end of the values array
	values=("${values[@]}" $difference)

	# update old traffic value
	traffic_old="${traffic_new}"

	# shift values / dequeue first element
	values=(${values[@]:1})

	echo "$(human_readable $((${difference} / ${delay}))) $(spark "${values[@]}") | ${line}" || exit 1
done
