main_loop()
{
	local cmd

	rm "$pipe"
	rmdir "$tmp_dir"
	
	IrcClient_nick "$irc_nick"
	IrcClient_user "$irc_username" "$irc_realname"
	while cmd="$(IrcClient_getCommand)"; do
		local inll
		#echo "cmd=$cmd" | sed 's/\r/\n/g' >&2
		eval "$(IrcCommand_unpack "$cmd")"
		#printf '%s\n' "received: $(IrcCommand_unpack "$cmd")" | sed -r 's/\r/\n/g' >&2
		if [ "$commandName" = "$ERR_NICKNAMEINUSE" ]; then
			inll=CONN
			exit ERR_SHII_NICKNAMEINUSE
		fi
	done
}
