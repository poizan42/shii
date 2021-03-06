irc_server=irc.freenode.net
irc_port=6667
irc_dir="$HOME/irc"
#irc_nick="$USER"
#irc_username="$USER"
runtime_dir_base="/tmp/shii"

while getopts ":s:i:n:u:f:k:r:" opt; do
	case $opt in
		s)
			irc_server="$OPTARG"
			;;
		i)
			irc_dir="$OPTARG"
			;;
		n)
			irc_nick="$OPTARG"
			;;
		u)
			irc_username="$OPTARG"
			;;
		f)
			irc_realname="$OPTARG"
			;;
		k)
			eval "irc_password=\"\$$OPTARG\""
			;;
		r)
			runtime_dir_base="$OPTARG"
			;;
		\?)
			echo "Invalid option: -$OPTARG" >&2
			;;
		:)
			echo "Option -$OPTARG requires an argument." >&2
			exit 1
			;;
	esac
done

if [ -z "$irc_username" ] && [ -z "$irc_nick" ]; then
	irc_username="$USER"
	irc_nick="$USER"
elif [ -z "$irc_username" ]; then
	irc_username="$irc_nick"
elif [ -z "$irc_nick" ]; then
	irc_nick="$irc_username"
fi

if [ -z "$irc_realname" ]; then
	irc_realname="$irc_username"
fi
