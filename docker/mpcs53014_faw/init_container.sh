#!/bin/bash
# https://docs.docker.com/config/containers/multi-service_container/

# Start SSH
service ssh restart
status=$?
if [ $status -ne 0 ]; then
  echo "Failed to start SSH for Hadoop: $status"
  exit $status
fi

/etc/init.d/mysql start

# Create Hive directories
sudo -u hadoop -H sh -c "echo executing start-all.sh; cd; /home/hadoop/hadoop/sbin/start-all.sh"
sudo -u hadoop -H sh -c "echo executing hdfs dfs -put /home/hadoop/inputs /inputs;  /home/hadoop/hadoop/bin/hdfs dfs -put /home/hadoop/inputs /inputs"
sudo -u hadoop -H sh -c "echo executing rm -r /home/hadoop/inputs;  rm -r /home/hadoop/inputs"
sudo -u hadoop -H sh -c "echo executing hdfs dfs -put /home/hadoop/user/hive/warehouse/* /user/hive/warehouse;  /home/hadoop/hadoop/bin/hdfs dfs -put /home/hadoop/user/hive/warehouse/* /user/hive/warehouse"
sudo -u hadoop -H sh -c "echo executing rm -r /home/hadoop/user;  rm -r /home/hadoop/user"
sudo -u hadoop -H sh -c "echo executing hiveserver2; cd; /home/hadoop/hive/bin/hiveserver2 &"
sudo -u hadoop -H sh -c "echo Giving hiveserver2 time; sleep 180"
sudo -u hadoop -H sh -c "echo executing beeline; cd; /home/hadoop/spark/bin/beeline -u jdbc:hive2://localhost:10000/default -f init_tables.hql"

sudo -u hadoop -H sh -c "echo executing stop-all.sh; cd; /home/hadoop/hadoop/sbin/stop-all.sh"



