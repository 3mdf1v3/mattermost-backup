#!/bin/bash
DATE=$(date +%Y-%m-%d-%H%M%S)
DESTINATION='./backup'
FILETOBACKUP='./system-file-backup.txt'
MYSQLFILE="${DESTINATION}/mariadb-${DATE}.sql"
CONTAINERIP=$(docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' mariadb)

mysqldump -u dbbackup -h ${CONTAINERIP} --all-databases --lock-tables=0 > ${MYSQLFILE}

echo './mattermost/data/' >> ${FILETOBACKUP}
echo './mattermost/config/' >> ${FILETOBACKUP}
echo ${MYSQLFILE} >> ${FILETOBACKUP}

find ${DESTINATION} -type f -mtime +7 -exec rm -f {} \;

tar -czpf "${DESTINATION}/backup-${DATE}.tar.gz" -T ${FILETOBACKUP}
rm -f ${MYSQLFILE} ${FILETOBACKUP}
                                   
