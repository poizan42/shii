NL="$(printf '\n')"
CR="$(printf '\r')"

ERR_SHII_PIPEBROKEN=100
ERR_SHII_NICKNAMEINUSE=101

ShiiUtils_escape()
{
	input="$1"
	printf "%s" "$input" | Csed "s/'/'\\\\''/g;s/^.*$/'\0'/"
}

ShiiUtils_escapeInner()
{
	input="$1"
	printf '%s' "$input" | Csed "s/'/'\\\\''/g"
}

ShiiUtils_escapeInnerPipe()
{
	Csed "s/'/'\\\\''/g"
}

ShiiUtils_dictStore() #dict:string,key:string,value:string
{
	local dict="$1" key="$2" value="$3"
	eval "${dict}_$(ShiiUtils_escapeName "$key")=$(ShiiUtils_escape "$value")"
}

ShiiUtils_dictLoad() #dict:string,key:string,outVar:string
{
	local dict="$1" key="$2"
	eval "$outVar=\"\$${dict}_$(ShiiUtils_escapeName "$key")\""
}

ShiiUtils_escapeName() #name:string
{
	local execVal
	execVal=\""$(printf '%s' "$1" | Csed -r "
		s/_/_5f/g
		s/'/_27/g
		s/[^a-zA-Z0-9_]+/\$(printf '%s' '\0' | xxd -p | sed 's@[0-9a-f][0-9a-f]@_\\\\''0@g')/g
		s/^[0-9]/_3\\0/"
		)"\"
	eval printf %s "$execVal"
}

# Because sed can't handle invalid utf-8 sequences in a sane way
Csed()
{
	LANG=C sed "$@"
}
