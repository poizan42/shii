NL="$(printf '\n')"
CR="$(printf '\r')"

ERR_PIPEBROKEN=100

ShiiUtils_escape()
{
	input="$1"
	printf "'%s'" "$input" | sed "s/'/'\"'\"'/g"
}

ShiiUtils_escapeInner()
{
	input="$1"
	printf '%s' "$input" | sed "s/'/'\"'\"'/g"
}

ShiiUtils_escapeInnerPipe()
{
	sed "s/'/'\"'\"'/g"
}
