#!/bin/bash
#############################################################
# Created by: Arbab Nazar (tendo.linux{at}gmail(dot)com)    #
#                                                           #                                                                                                                    #
#############################################################
## Specify the name of the database that you want to backup
DATABASE="tendodb"

## USERNAME and PASSWORD to take the backup
USER="arbab"
PASSWORD="PASSWORD"
## Defination of some necessary variables
S3_BUCKET=tendodbbackup
DATE=`date +%A-"(%d.%m.%Y)".%H`
BACKUP_LOC=/tmp/backups
S3BDIR=`date +%d.%A-"(%d.%m.%Y)"`
mysql_backup(){
/usr/bin/mysqldump -u $USER -p$PASSWORD --databases $DATABASE | gzip -9 > $BACKUP_LOC/tendodb_$DATE.sql.gz
 s3cmd ls s3://$S3_BUCKET/$S3BDIR > /tmp/log.txt
 grep -lr "$S3BDIR" /tmp/log.txt
 if [ $? -ne 0 ]
 then
 mkdir /tmp/$S3BDIR
 s3cmd put -r /tmp/$S3BDIR s3://$S3_BUCKET/
s3cmd sync -r $BACKUP_LOC/ s3://$S3_BUCKET/$S3BDIR/
else
 s3cmd sync -r $BACKUP_LOC/ s3://$S3_BUCKET/$S3BDIR/
fi
}
mysql_backup
echo "----------------------------------------------------------------------------------------------" >> /scripts/dbbackup.log
echo "Backup Successfully uploading to the S3 Bucket at `date +%A.%Y%m%d-%H.%M`" >> /script/dbbackup.log
echo "##############################################END#############################################" >> /scripts/dbbackup.log
rm -rf $BACKUP_LOC/* /tmp/$S3BDIR
exit 0
