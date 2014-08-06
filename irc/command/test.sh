#!/bin/sh
. ../../ShiiUtils.sh
. ./IrcCommand.sh

testCmd=':nickOrServer!user@host PING foo bar : cookie med foo:bar :baz'
cmd="$(IrcCommand_parse "$testCmd")"
IrcCommand_unpack "$cmd" | sed -r 's/\r/\n/g'
