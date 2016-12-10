sqlFile=ddfs_Fri.sql

#get only create tables
sed -n -e '/CREATE TABLE/,/;/p' $sqlFile > tableCreation.sql

#remove constraints in the tables
sed '/CONSTRAINT/d' tableCreation.sql > noContraints.sql
#remove trailing commas that might have appeared
perl -0777 -i -pe 's/,\n\)/\n\)/g' noContraints.sql 
#remove engine information
sed -i 's/^) ENGINE.*;/);/g' noContraints.sql

#make a file with just tableNames
cat tableCreation.sql | grep "CREATE TABLE" | cut -d' ' -f3 > tableNames

# # make tables folder
# mkdir tables

# #get each individual tables in separate file
# for f in $(cat tableNames); do sed -n -e "/LOCK TABLES $f/,/UNLOCK TABLES/p" $sqlFile > tables/$f ;echo $f; done
# # rename the files to better names (remove surrounding ` and append .sql)
# cd tables
# for f in *; do mv $f ${f%\`}; done
# for f in *; do mv $f ${f/\`}; done
# for f in *; do mv $f $f.sql; done
# cd ..


#get word count information
wc tables/* > wordCountInfo

#find which all tables are empty, ie have no content (check for ones with only 4 lines)
wc -l tables/* | grep "\b4\b" | cut -f11 -d' ' > emptyTables


#remove those tables
for f in $(cat emptyTables); do rm $f; done

# # Separate inserted values into single lines
cd tables
for f in *.sql; do echo $f; cat $f | grep -hoP "\(.*?\)[,;]" > ../values/${f%.sql}; done
cd ..