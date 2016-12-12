tables=$(mysql -h 127.0.0.1 -u root --execute="SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'ddfs' and TABLE_ROWS=0";)
tables=$(echo $tables | cut -f2- -d' ')
for f in $tables; do mysql -h 127.0.0.1 -u root --execute="use ddfs; drop table $f;"; done
# 