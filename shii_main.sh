main_loop()
{
	rm "$pipe"
	rmdir "$tmp_dir"
	while read line; do
		echo "received \"$line\"" >&2
	done
}
