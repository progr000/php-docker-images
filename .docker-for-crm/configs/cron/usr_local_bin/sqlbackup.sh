#!/bin/bash
#echo "Alle MySQL-Datenbanken sichern:"
# Bereinigte Liste der Datenbanken erzeugen
# "geheim" ist das MySQL-Rootpasswort:
DBASELIST=`mktemp`
/usr/bin/mysqlshow -pMN_tuxAPPS_$\@2013 | awk '{print $2}' | grep -v Databases | sort >$DBASELIST
# Wohin sollen die ganzen Backups geschrieben werden?
cd /home/mysql_backup/
rm -rf daily.6
mv daily.5 daily.6
mv daily.4 daily.5
mv daily.3 daily.4
mv daily.2 daily.3
mv daily.1 daily.2
mv current daily.1
mkdir -p current
cd current
for x in `cat $DBASELIST`; do
#echo "Datenbank: $x sichern";
mysqldump --single-transaction --opt -pMN_tuxAPPS_$\@2013 $x >$x.sql;
done;
#echo "Alte .gz-Dateien loeschen:"
#rm *.gz
#echo "Dateien zippen:"
gzip *
