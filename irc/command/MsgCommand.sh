MsgCommand_create() #fullCommand:string, command:string, params:string, has_prefix:bool, [p_host:string, p_nickOrServer:string, p_user:string]
{
	this="$(IrcCommand_create() "$@")"
	IrcCommand_unpack "$this"
	eval "_MsgCommand_loadParams $parameters"
	printf '%s' "$this"
}

_MsgCommand_loadParams()
{
}

_MsgCommand_unpackExtraCore() #prefix:string,message:string,receiver:string,sender:string,isCtcp:bool[,ctcpMessage:string]
{
	local prefix="$1" message="$2" receiver="$3" sender="$4" isCtcp="$5" ctcpMessage="$6"
	local p="local $prefix"
	printf "
		message=%s
		receiver=%s
		sender=%s
		isCtcp=%s
		ctcpMessage=%s" \
		"$message" "$receiver" "$sender" "$isCtcp" "$ctcpMessage" |
		Csed -r "
			h
			s/^\s*\w+=(.*)$/\1/
			s/'/'\\\\''/g
			s/^.*$/='\0'/
			x
			s/^\s*(\w+)=.*$/${p}\1/
			G
			s/\n//"
}

_MsgCommand_unpackExtra() #extra:array,prefix:string
{
	local extra="$1" prefix="$2"
	eval "_MsgCommand_unpackExtraCore $prefix $extra"
}

IrcCommand_addCommand MsgCommand NOTICE
IrcCommand_addCommand MsgCommand PRIVMSG
