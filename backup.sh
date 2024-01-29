#!/bin/bash
DDATE=`date "+%Y%m%d-%H%M"`
echo "saving...$DDATE"
cd ~/pal_backup
cp -r /home/ubuntu/Steam/steamapps/common/PalServer/Pal/Saved ./
tar -czf $DDATE.tar.gz ./Saved

find ./ -regex '.*[0-9]+.[0-9]+\.tar\.gz$' -mtime +3 -delete;
