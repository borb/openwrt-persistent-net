#!/bin/sh
# Deal with renaming network interfaces and static name mapping

_ifrename() {
	local _iface=$1

	# ensure the device exists
	[ ! -r /sys/class/net/$_iface/address ] && return

	# grab the static map from persistent-net-map
	local _mac=$(cat /sys/class/net/$_iface/address)

	# check we aren't operating on loopback or have no mac address
	[ -z "$_mac" -o "$_mac" = "00:00:00:00:00:00" ] && return

	# grab the new interface name
	local _newname=$(grep -i "^$_mac" /etc/persistent-net-map | tail -n1 | sed -E 's/^.*[ \t]+(.*)$/\1/')

	# no map? don't perform a rename
	[ -z "$_newname" ] && return

	# make the change
	ip link set $_iface name $_newname
}

