FROM mspertus/mpcs53014_hive_hbase:latest

MAINTAINER Mike Spertus <mike@spertus.com>

# Install Node.js
RUN curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -
RUN apt-get install -y nodejs

# Switch To Hadoop User
USER hadoop
WORKDIR /home/hadoop

COPY create_hbase_table.txt /home/hadoop/create_hbase_table.txt

RUN mkdir /home/hadoop/inputs
COPY inputs /home/hadoop/inputs
RUN mkdir -p /home/hadoop/user/hive/warehouse
COPY user/hive/warehouse /home/hadoop/user/hive/warehouse

COPY IngestWeather-0.0.1-SNAPSHOT.jar /home/hadoop/IngestWeather-0.0.1-SNAPSHOT.jar
COPY init_tables.hql /home/hadoop/init_tables.hql

# Switch back to Root User
USER root
WORKDIR /
RUN chown -R hadoop:hadoop /home/hadoop/inputs
RUN chown -R hadoop:hadoop /home/hadoop/user
RUN echo "export PATH=\$PATH:/home/hadoop/hbase/bin" >>/home/hadoop/.bashrc

COPY init_container.sh /init_container.sh
COPY create_hbase_table.sh /create_hbase_table.sh
COPY write_to_hbase.hql /home/hadoop/write_to_hbase.hql
RUN chown hadoop:hadoop /home/hadoop/write_to_hbase.hql
COPY populate_hbase_table.sh /populate_hbase_table.sh


RUN /init_container.sh
RUN /create_hbase_table.sh
RUN /populate_hbase_table.sh

# Switch To Hadoop User
USER hadoop
WORKDIR /home/hadoop
RUN mkdir webapp
ADD webapp.tar.gz /home/hadoop
WORKDIR /home/hadoop/webapp
RUN npm install express
RUN npm install mustache
RUN npm install hbase-rpc-client

USER root
WORKDIR /

#Expose Hadoop Ports
EXPOSE 8088 9870 9000 10000 4040 8042 8030 8031 8032 8888 30000-50000 3000-3100

# Start startup Script
ENTRYPOINT ["/startup_hive.sh"]


