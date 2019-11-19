#!/bin/bash
# https://docs.docker.com/config/containers/multi-service_container/

# Start SSH
service ssh restart
status=$?
if [ $status -ne 0 ]; then
  echo "Failed to start SSH for Hadoop: $status"
  exit $status
fi

sudo -u hadoop -H sh -c "echo executing start-all.sh; cd; /home/hadoop/hadoop/sbin/start-all.sh"
sudo -u hadoop -H sh -c "echo start-hbase.sh; cd; . /home/hadoop/.bashrc; /home/hadoop/hbase/bin/start-hbase.sh; sleep 10"
sudo -u hadoop -H sh -c "echo hbase shell /home/hadoop/create_hbase_table.txt; cd;  . /home/hadoop/.bashrc; /home/hadoop/hbase/bin/hbase shell  /home/hadoop/create_hbase_table.txt"
sudo -u hadoop -H sh -c "echo executing stop-all.sh; cd; /home/hadoop/hadoop/sbin/stop-all.sh"
