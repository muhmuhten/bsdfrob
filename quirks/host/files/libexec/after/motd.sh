: "${motd=/etc/motd}"
sysctl -n kern.version | {
	read ostype osrelease rest
	read build
	echo "$ostype $osrelease (${build##*/}) $rest"

	{
		read line
		case $line in
		("$ostype "*) ;;
		(*)
			printf '\n%s\n' "$line" ;;
		esac

		while read line; do
			printf '%s\n' "$line"
		done
	} <&4
} 3>&2 2>/dev/null 4< "$motd" > "$motd.new" 2>&3 3>&- && mv "$motd.new" "$motd"
