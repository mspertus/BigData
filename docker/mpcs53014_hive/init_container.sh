#!/bin/bash
# https://docs.docker.com/config/containers/multi-service_container/

# Start SSH
service ssh restart
status=$?
if [ $status -ne 0 ]; then
  echo "Failed to start SSH for Hadoop: $status"
  exit $status
fi

# Fromat HDFS and Setup Hive 
CONTAINER_ALREADY_INITIALIZED_HIVE="CONTAINER_ALREADY_INITIALIZED_HIVE"
if [ ! -e $CONTAINER_ALREADY_INITIALIZED_HIVE ]; then
    touch $CONTAINER_ALREADY_INITIALIZED_HIVE
    echo "First start of container."
    	/etc/init.d/mysql start
    
    	# Format HDFS
	echo "Format HDFS."
	sudo -u hadoop -H sh -c "echo Switched to User:; whoami; cd; /home/hadoop/hadoop/bin/hdfs namenode -format"
	status=$?
	if [ $status -ne 0 ]; then
  	  echo "Failed to format HDFS: $status"
  	  exit $status
	fi

	# Create Hive directories
        echo "Create Hive directories within HDFS."
	sudo -u hadoop -H sh -c "echo executing start-all.sh; cd; /home/hadoop/hadoop/sbin/start-all.sh"
        sudo -u hadoop -H sh -c "echo executing hadoop fs -mkdir -p /user/hive/warehouse; cd; /home/hadoop/hadoop/bin/hadoop fs -mkdir -p /user/hive/warehouse"
	sudo -u hadoop -H sh -c "echo executing hadoop fs -chmod g+w /user/hive/warehouse; cd; /home/hadoop/hadoop/bin/hadoop fs -chmod g+w /user/hive/warehouse"
	sudo -u hadoop -H sh -c "echo executing hadoop fs -mkdir -p /tmp; cd; /home/hadoop/hadoop/bin/hadoop fs -mkdir -p /tmp"
        sudo -u hadoop -H sh -c "echo executing hadoop fs -chmod g+w /tmp; cd; /home/hadoop/hadoop/bin/hadoop fs -chmod g+w /tmp"
	sudo -u hadoop -H sh -c "echo executing hadoop fs -mkdir /user/hadoop; cd; /home/hadoop/hadoop/bin/hadoop fs -mkdir /user/hadoop"
	sudo -u hadoop -H sh -c "echo executing hive/bin/schematool -initSchema -dbType mysql; cd; /home/hadoop/hive/bin/schematool -initSchema -dbType mysql"

	sudo -u hadoop -H sh -c "echo executing stop-all.sh; cd; /home/hadoop/hadoop/sbin/stop-all.sh"
else
    echo "Not first start of Container, no HDFS format or Hive Setup necessary."
fi

echo "Container Startup finished."

# Start Hadoop Cluster
#sudo -u hadoop -H sh -c "echo Switched to User:; whoami; cd; /home/hadoop/hadoop/sbin/start-all.sh"
#status=$?
#if [ $status -ne 0 ]; then
#  echo "Failed to start Hadoop DFS and Yarn: $status"
#  exit $status
#fi

