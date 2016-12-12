for f in values/*; do
	files=$(find $f -path "*[0-9]" | sort -n)
	for g in $files; do
		insertValues=$(cat $g | sed -e :a -e '/^\n*$/{$d;N;ba' -e '}' | sed -e '$s/,$/;/')
		echo "insert into ${f/values\/} values $insertValues" > tempfile
	done
	echo $f${f/values}00
done
