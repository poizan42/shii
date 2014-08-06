irc_server=irc.freenode.net
irc_port=6667
irc_dir="$HOME/irc"
irc_nick="$USER"
runtime_dir_base="/var/run"

while getopts ":s:i:n:f:k:r:" opt; do
	case $opt in
		s)
			irc_server="$OPTARG"
			;;
		i)
			irc_dir="$OPTARG"
			;;
		n)
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

if [ -z "$irc_realname" ]; then
	irc_realname="$irc_nick"
fi
