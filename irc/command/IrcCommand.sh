IrcCommand_create() #fullCommand:string, command:string, params:string, has_prefix:bool, [p_host:string, p_nickOrServer:string, p_user:string]
{
	local fullCommand="$1"; local command="$2"; local params="$3"; local has_prefix="$4"
	if [ "$has_prefix" = "1" ]; then
		local p_host="$5"
		local p_nickOrServer="$6"
		local p_user="$7"
	else
		has_prefix=0
	fi
	local parameters="$(_IrcCommand_parseParams "$params")"
	printf 'IrcCommand\r%s\r%s\r%s\r%s\r%s\r%s\r%s\r%s' \
		"$fullCommand" "$command" "$params" \
		"$has_prefix" "$p_host" "$p_nickOrServer" "$p_user" \
		"$parameters"
}

IrcCommand_getFullCommand() #this:IrcCommand
{
	local this="$1"
	printf '%s' "$this" |
	(
		IFS="$CR" read -r x fullCommand x
		printf '%s' "$fullCommand"
	)
}

IrcCommand_getCommandName() #this:IrcCommand
{
	local this="$1"
	printf '%s' "$this" |
	(
		IFS="$CR" read -r x x commandName x
		printf '%s' "$commandName"
	)
}

IrcCommand_getParamsStr() #this:IrcCommand
{
	local this="$1"
	printf '%s' "$this" |
	(
		IFS="$CR" read -r x x x paramsStr x
		printf '%s' "$paramsStr"
	)
}

IrcCommand_getHasPrefix() #this:IrcCommand
{
	local this="$1"
	printf '%s' "$this" |
	(
		IFS="$CR" read -r x x x x hasPrefix x
		printf '%s' "$hasPrefix"
	)
}

IrcCommand_getHost() #this:IrcCommand
{
	local this="$1"
	printf '%s' "$this" |
	(
		IFS="$CR" read -r x x x x x host x
		printf '%s' "$host"
	)
}

IrcCommand_getNickOrServer() #this:IrcCommand
{
	local this="$1"
	printf '%s' "$this" |
	(
		IFS="$CR" read -r x x x x x x nickOrServer x
		printf '%s' "$nickOrServer"
	)
}

IrcCommand_getUser() #this:IrcCommand
{
	local this="$1"
	printf '%s' "$this" |
	(
		IFS="$CR" read -r x x x x x x x user x
		printf '%s' "$user"
	)
}

IrcCommand_getParameters() #this:IrcCommand
{
	local this="$1"
	printf '%s' "$this" | tail -n +9
}

# returns a string that can be eval'ed to get the values more efficiently
IrcCommand_unpack() #this:IrcCommand,prefix:string
{
	local this="$1"; local prefix="$2"
	# The escaping won't affect the newline delimiters
	ShiiUtils_escapeInner "$this" |
	(
		IFS="$CR" read -r x fullCommand commandName paramsStr hasPrefix host nickOrServer user parameters
		local p="local $prefix"
		printf "
			${p}fullCommand='%s';
			${p}commandName='%s';
			${p}paramsStr='%s';
			${p}hasPrefix='%s';
			${p}host='%s';
			${p}nickOrServer='%s';
			${p}user='%s';
			${p}parameters='%s'" \
			"$fullCommand" "$commandName" "$paramsStr" \
			"$hasPrefix" "$host" "$nickOrServer" \
			"$user" "$parameters"
	)
}

_IrcCommand_parseParams() #params:string
{
	local params="$1"
	echo "params=$(printf '%s' "$params" | sed -r 's/\r/\n/g')" >&2
	tmp="$(
	printf '%s' "$params" |
		sed -r '{1 s/(.) ?:/\1\r/};t rep;{s/ /\r/g};{:rep;s/ (.*\r)/\r\1/g;t rep}')"
	printf '%s' "$tmp" | sed -r 's/\r/\n/g' >&2
	printf '%s' "$tmp"
}

_IrcCommand_parsedToVars() #
{
	commandName="$1"
	params="$2"
	if [ "$3" = ":" ]; then
		hasPrefix=1
	else
		hasPrefix=0
	fi
	p_host="$4"
	p_nickOrServer="$5"
	p_user="$6"
}

IrcCommand_parse() #cmdStr:string
{
	local cmdStr="$1"
	# We escape this safely because " and ' has no significance
	# in the command format
	local parsed="$(printf '%s' "$cmdStr" |
		ShiiUtils_escapeInnerPipe |
		sed -r 's/^((:)([^!@ ]*)((!([^@ ]*))?@([^ ]*))?\s+)?([^ ]*)\s*(.*)/'"'\8' '\9' '\2' '\7' '\3' '\6'/")"
	eval "_IrcCommand_parsedToVars $parsed"
	IrcCommand_create "$cmdStr" "$commandName" "$params" "$hasPrefix" "$p_host" "$p_nickOrServer" "$p_user"
	unset commandName params hasPrefix p_host p_nickOrServer p_host
}
