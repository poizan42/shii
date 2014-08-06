# based on https://github.com/poizan42/arpobot/blob/master/irc/IrcClient.java

IrcClient_pass() #pass: string
{
	pass="$1"
	command="PASS $pass"
	IrcClient_execute "$command" USERINF
}

IrcClient_nick() #nickname: string
{
	nickname="$1"
	command="NICK $nickname"
	IrcClient_execute "$command" USERINF
}

IrcClient_user() #username:string, realname:string
{
	local username="$1" realname="$2"
	local mode=8
	command="USER $username $mode * :$realname;"
	IrcClient_execute "$command" USERINF
}

IrcClient_join() #channel:string, [password:string]
{
	channel="$1"; password="$2"
	command="JOIN $channel"
	if [ -n "$password" ]; then
		command="$command $password"
	fi
	IrcClient_execute "$command" CHAN
}

IrcClient_topic() #channel:string, topic:string
{
	channel="$1"; topic="$2"
	command="TOPIC $channel :$topic"
	IrcClient_execute "$command" CHAN
}

IrcClient_pong() #cookie:string
{
	cookie="$1"
	command="PONG :$cookie"
	IrcClient_execute "$command" DEBUG
}

IrcClient_execute() #command:string, logLevel:LogLevel
{
	command="$1"; logLevel="$2"
	printf '%s\n' "$command" # the CR is inserted by sed in the main script
	
	IrcClient_log "$command" "$loglevel"
}

IrcClient_log() #command:string, logLevel:LogLevel
{
	command="$1"; logLevel="$2"
	printf '%s\n' "<-- ($logLevel) $command" >&2
}

IrcClient_getLine()
{
	if ! read -r LINE && [ -z "$LINE" ]; then
		return $ERR_PIPEBROKEN
	fi
	printf '%s' "$LINE"
}

IrcClient_getCommand()
{
	line="$(IrcClient_getLine)" && IrcCommand_parse "$line"
}
