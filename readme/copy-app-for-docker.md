#### Command will create the similar dir-structure as on the server for web1 folder:
```bash
find /home/www/web1 -type d -exec mkdir -p /tmp/progr000{} \;
```
***

#### Command will copy all files to new directory structure (from prev command) except some extension and files with size more than 30mb 
```bash
find /home/www/web1 -regextype posix-egrep ! -iregex ".*\.(pdf|zip|log|csv|txt)" -size -30M -type f -exec cp {} /tmp/progr000{} \;
```
***

#### Copy for links
```bash
find /home/www/web1 -type l -exec cp {} /tmp/progr000{} \;
```
