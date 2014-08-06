main_loop()
{
	local cmd

	rm "$pipe"
	rmdir "$tmp_dir"
	
	IrcClient_nick "$irc_nick"
	IrcClient_user "$irc_username" "$irc_realname"
	while cmd="$(IrcClient_getCommand)"; do
		echo "cmd=$cmd" | sed 's/\r/\n/g' >&2
		printf '%s\n' "received: $(IrcCommand_unpack "$cmd")" | sed -r 's/\r/\n/g' >&2
	done
}
