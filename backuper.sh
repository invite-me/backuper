#! /bin/bash

PASSWORD=""
HOST=""
USER="root"
TABLE="invite_me"

cwd="$(dirname $(realpath -- "$0";) )/"
echo $cwd

filename="tmp.sql"
filename="$cwd/$filename"

backup_dir="$cwd/backup/"

config_file="$cwd/.my.cnf"
touch $config_file

echo [mysqldump] >  $config_file
echo password=$PASSWORD >> $config_file

while [[ 1 ]]; do
        if [[ -f $filename ]]; then
                mv $filename $filename.old
        else
                touch $filename.old
        fi
        # cat $filename.old
        # echo old

        mysqldump  --defaults-file=$config_file --host $HOST -u $USER $TABLE > $filename

        head -n -1 $filename > $filename.tmp
        mv $filename.tmp $filename


        if [[ $(diff $filename $filename.old) != "" ]]; then
                echo $(diff $filename $filename.old)
                echo difference found
                cp "$filename" "${backup_dir}/sql$(date '+%Y-%m-%d_%H:%M')"

        fi


        sleep 600
        echo config dumped to "$filename"



done