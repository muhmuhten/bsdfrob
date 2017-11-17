sysctl net.inet.ip.portrange.reservedhigh=0

(read host < /media/host/hostname && hostname "$host")

if [ -e /media/host/pf.conf ]; then
	kldload pf
	pfctl -ef /media/host/pf.conf
fi

ifconfig lo0 inet 127.1/8 alias
for interface in `ifconfig -l`; do
	ifconfig "$interface" inet6 -ifdisabled
done

ifconfig lo1 create
