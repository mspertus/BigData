FROM marcelmittelstaedt/spark_base:latest

MAINTAINER Mike Spertus <mike@spertus.com>

# Switch hive to use mysql metastore
RUN /bin/bash -c "debconf-set-selections <<< 'mysql-server mysql-server/root_password password hadoop'"
RUN /bin/bash -c "debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password hadoop'"
RUN apt-get install -y mysql-server
RUN apt-get install -y libmysql-java

# Switch To Hadoop User
USER hadoop
WORKDIR /home/hadoop
RUN ln -s /usr/share/java/mysql-connector-java.jar /home/hadoop/hive/lib/mysql-connector-java.jar
COPY core-site.xml hadoop/etc/hadoop/core-site.xml
COPY hive-site.xml hive/conf

# Switch back to Root User
USER root
WORKDIR /

COPY init_container.sh /init_container.sh

RUN /init_container.sh
COPY startup_hive.sh /startup_hive.sh
COPY startup.sh /startup.sh

#Expose Hadoop Ports
EXPOSE 8088 9870 9000 10000 4040 8042 8030 8031 8032 8888 30000-50000 3000-3100

# Start startup Script
ENTRYPOINT ["/startup.sh"]


