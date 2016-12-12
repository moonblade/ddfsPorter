databaseName="ddfs"
for f in values/*; do
	files=$(find $f -path "*[0-9]" | sort -n)
	for g in $files; do
	  	# remove trailing null lines  with sed -e :a -e '/^\n*$/{$d;N;ba' -e '}' 
		insertValues=$(cat $g | sed -e '$s/,$/;/')
		insertCommand="insert into ${f/values\/} values $insertValues" 
		echo $insertCommand > tempfile
		mysql -h 127.0.0.1 --user="ddfs" --execute="use $databaseName;$insertCommand"
		echo $g 
	done
done
