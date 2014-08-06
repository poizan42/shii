#!/bin/sh
dir="$(readlink -f "$(dirname "$0")")"

. "$dir/../../ShiiUtils.sh"
. "$dir/IrcCommand.sh"
. "$dir/../IrcClient.sh"

#testCmd=':nickOrServer!user@host PING foo bar : cookie med foo:bar :baz'
testCmd=':cameron.freenode.net NOTICE * :*** Looking up your hostname...'
#cmd="$(IrcCommand_parse "$testCmd")"
cmd="$(printf '%s' "$testCmd" | IrcClient_getCommand)"
IrcCommand_unpack "$cmd" | sed -r 's/\r/\n/g'
echo
