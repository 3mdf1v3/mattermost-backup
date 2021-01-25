#!/bin/bash
DATE=$(date +%Y-%m-%d-%H%M%S)
DESTINATION='/root/mattermost-backups'
BACKUPFILES="${DESTINATION}/mattermost-backup-${DATE}.list"
MYSQLFILE="${DESTINATION}/mariadb-${DATE}.sql"

mysqldump -u root --all-databases > ${MYSQLFILE}

find ${DESTINATION} -name '*.tar.gz' -type f -mtime +7 -exec rm -f {} \;

echo '/opt/mattermost/config/config.json' >> ${BACKUPFILES}
echo '/opt/mattermost/data/' >> ${BACKUPFILES}

echo ${MYSQLFILE} >> ${BACKUPFILES}

tar -czpf "${DESTINATION}/mattermost-backups-${DATE}.tar.gz" -T ${BACKUPFILES}

rm -f ${DESTINATION}/*.sql ${DESTINATION}/*.list

A="$(ls -als /root/mattermost-backups/*.tar.gz)"
B="{\"text\":\"#### Controllo backup mattermost del ${DATE}:\n<!channel> controllate la lista completa dei backup eseguiti.\n\`\`\` bash\n${A}\n\`\`\`\"}"
curl -i -k -X POST -H 'Content-Type: application/json' -d "${B}" ${MATTERMOSTBOTURI}
