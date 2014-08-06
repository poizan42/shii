# based on https://github.com/poizan42/arpobot/blob/master/irc/IrcClient.java

IrcClient_pass() #pass: string
{
	local pass="$1"
	local command="PASS $pass"
	IrcClient_execute "$command" USERINF
}

IrcClient_nick() #nickname: string
{
	local nickname="$1"
	local command="NICK $nickname"
	IrcClient_execute "$command" USERINF
}

IrcClient_user() #username:string, realname:string
{
	local username="$1" realname="$2"
	local mode=8
	local command="USER $username $mode * :$realname;"
	IrcClient_execute "$command" USERINF
}

IrcClient_join() #channel:string, [password:string]
{
	local channel="$1" password="$2"
	local command="JOIN $channel"
	if [ -n "$password" ]; then
		command="$command $password"
	fi
	IrcClient_execute "$command" CHAN
}

IrcClient_topic() #channel:string, topic:string
{
	local channel="$1" topic="$2"
	local command="TOPIC $channel :$topic"
	IrcClient_execute "$command" CHAN
}

IrcClient_pong() #cookie:string
{
	local cookie="$1"
	local command="PONG :$cookie"
	IrcClient_execute "$command" DEBUG
}

IrcClient_execute() #command:string, logLevel:LogLevel
{
	local command="$1" logLevel="$2"
	printf '%s\n' "$command" # the CR is inserted by sed in the main script
	
	IrcClient_log "$command" "$loglevel"
}

IrcClient_log() #command:string, logLevel:LogLevel
{
	local command="$1" logLevel="$2"
	printf '%s\n' "<-- ($logLevel) $command" >&2
}

IrcClient_getLine()
{
	local LINE
	if ! read -r LINE && [ -z "$LINE" ]; then
		return $ERR_PIPEBROKEN
	fi
	printf '%s' "$LINE"
}

IrcClient_getCommand()
{
	local line
	line="$(IrcClient_getLine)" && IrcCommand_parse "$line"
}
