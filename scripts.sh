#get only create tables
sed -n -e '/CREATE TABLE/,/;/p' ddfs_Fri.sql > tableCreation.sql

#remove constraints in the tables
sed '/CONSTRAINT/d' tableCreation.sql > noContraints.sql
#remove trailing commas that might have appeared
perl -0777 -i -pe 's/,\n\)/\n\)/g' noContraints.sql 
#remove engine information
sed -i 's/^) ENGINE.*;/);/g' noContraints.sql

#make a file with just tableNames
cat tableCreation.sql | grep "CREATE TABLE" | cut -d' ' -f3 > tableNames

# make tables folder
# mkdir tables

#get each individual tables in separate file
# for f in $(cat tableNames); do sed -n -e "/LOCK TABLES $f/,/UNLOCK TABLES/p" ddfs_Fri.sql > tables/$f ;echo $f; done
# rename the files to better names (remove surrounding ` and append .sql)
for f in *; do mv $f ${f%\`}; done
for f in *; do mv $f ${f/\`}; done
for f in *; do mv $f $f.sql; done



#get word count information
wc tables/* > wordCountInfo

#find which all tables are empty, ie have no content
wc -l tables/* | grep "\b4\b" | cut -f11 -d' ' > emptyTables


#remove those tables
for f in $(cat emptyTables); do rm $f; done